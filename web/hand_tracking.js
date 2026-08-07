// web/hand_tracking.js
window.handTracking = (() => {
  const FINGER_TIPS = [4, 8, 12, 16, 20];
  const FINGER_MAP = { 4: 1, 8: 2, 12: 3, 16: 4, 20: 5 };
  const FINGER_TO_STRING = { 1: 1, 2: 4, 3: 6, 4: 8, 5: 10 };
  const STRING_TO_LANDMARK = { 1: 4, 4: 8, 6: 12, 8: 16, 10: 20 };
  const ACTIVE_STRINGS_REAL = [1, 4, 6, 8, 10];
  const ALL_STRINGS = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
  const STRING_DISPLAY_NAMES = { 1: '1', 4: '2', 6: '3', 8: '4', 10: '5' };
  const CALIBRATION_KEY = 'begena_string_positions';
  const MOVEMENT_THRESHOLD = 15;

  const SOUND_PATHS = {
    selamta: { 1: '/sounds/string1.wav', 2: '/sounds/string2.wav', 3: '/sounds/string3.wav', 4: '/sounds/string4.wav', 5: '/sounds/string5.wav' },
    tezeta: { 1: '/sounds/tezeta1.wav', 2: '/sounds/tezeta2.wav', 3: '/sounds/tezeta3.wav', 4: '/sounds/tezeta4.wav', 5: '/sounds/tezeta5.wav' },
    anchihoye: { 1: '/sounds/anchihoye1.wav', 2: '/sounds/anchihoye2.wav', 3: '/sounds/anchihoye3.wav', 4: '/sounds/anchihoye4.wav', 5: '/sounds/anchihoye5.wav' },
  };

  function playSound(fingerNum, qenet) {
    const path = SOUND_PATHS[qenet]?.[fingerNum];
    if (path) new Audio(path).play().catch(() => {});
  }

  let handLandmarker = null;
  let videoEl = null;
  let canvasEl = null;
  let ctx = null;
  let stream = null;
  let running = false;
  let rafId = null;

  let qenet = 'selamta';
  let virtualStrings = false;
  let targetFinger = null; // 1-5, used for onString check + highlight

  let prevX = {};
  let prevY = {};
  let soundReady = true;
  let currentHand = null;
  let stringPositions = JSON.parse(localStorage.getItem(CALIBRATION_KEY) || 'null');
  let stringStates = Object.fromEntries(ALL_STRINGS.map((s) => [s, { vibrating: false, color: 'normal' }]));
  let vibrationTimers = {};

  const state = {
    ready: false,
    cameraReady: false,
    handTrackerReady: false,
    handVisible: false,
    lastPluck: null, // { finger, string, onString, timestamp }
  };

  async function init() {
    const { HandLandmarker, FilesetResolver } = window.__mpHandLandmarker;
    const vision = await FilesetResolver.forVisionTasks('https://cdn.jsdelivr.net/npm/@mediapipe/tasks-vision@0.10.14/wasm');
    handLandmarker = await HandLandmarker.createFromOptions(vision, {
      baseOptions: {
        modelAssetPath: 'https://storage.googleapis.com/mediapipe-models/hand_landmarker/hand_landmarker/float16/1/hand_landmarker.task',
        delegate: 'GPU',
      },
      runningMode: 'VIDEO',
      numHands: 1,
    });
    state.handTrackerReady = true;
  }

  function waitForElement(id, timeoutMs = 8000) {
    return new Promise((resolve, reject) => {
      const existing = document.getElementById(id);
      if (existing) return resolve(existing);
      const startedAt = Date.now();
      const timer = setInterval(() => {
        const el = document.getElementById(id);
        if (el) {
          clearInterval(timer);
          resolve(el);
        } else if (Date.now() - startedAt > timeoutMs) {
          clearInterval(timer);
          reject(new Error(`hand_tracking: element #${id} never appeared`));
        }
      }, 50);
    });
  }

  async function start(videoElementId, canvasElementId) {
    // Flutter mounts the platform-view <video>/<canvas> elements a frame
    // after build(), so they may not exist in the DOM the instant start()
    // is called (e.g. from initState()). Wait for them instead of assuming.
    videoEl = await waitForElement(videoElementId);
    canvasEl = await waitForElement(canvasElementId);
    ctx = canvasEl.getContext('2d');

    if (!handLandmarker) await init();

    stream = await navigator.mediaDevices.getUserMedia({ video: { width: 640, height: 480 } });
    videoEl.srcObject = stream;
    await new Promise((resolve) => {
      videoEl.onloadedmetadata = () => {
        videoEl.play();
        state.cameraReady = true;
        resolve();
      };
    });

    running = true;
    state.ready = true;
    loop();
  }

  function getStringX(stringNum, w) {
    if (stringPositions?.[stringNum] !== undefined) return stringPositions[stringNum];
    const margin = w * 0.08;
    const usable = w - margin * 2;
    return margin + ((stringNum - 1) / 9) * usable;
  }

  function vibrateString(stringNum, isCorrect) {
    if (vibrationTimers[stringNum]) clearTimeout(vibrationTimers[stringNum]);
    stringStates[stringNum] = { vibrating: true, color: isCorrect ? 'green' : 'red' };
    vibrationTimers[stringNum] = setTimeout(() => {
      stringStates[stringNum] = { vibrating: false, color: 'normal' };
    }, 600);
  }

  function processMovement(hand, w, h) {
    const movements = {};
    hand.forEach((lm, i) => {
      const x = lm.x * w;
      const y = lm.y * h;
      if (prevX[i] === undefined) prevX[i] = x;
      if (prevY[i] === undefined) prevY[i] = y;
      let move;
      if (i === 4) move = prevX[i] - x;
      else if (i === 20) move = x - prevX[i];
      else move = y - prevY[i];
      movements[i] = move;
      prevX[i] = x;
      prevY[i] = y;
    });

    let strongest = -1;
    let maxMove = -Infinity;
    FINGER_TIPS.forEach((i) => {
      if (movements[i] > maxMove) {
        maxMove = movements[i];
        strongest = i;
      }
    });

    if (maxMove > MOVEMENT_THRESHOLD && soundReady && strongest !== -1) {
      const fingerNum = FINGER_MAP[strongest];
      const expectedString = FINGER_TO_STRING[fingerNum];

      if (virtualStrings) {
        const fingerTipX = hand[strongest].x * w;
        const expectedX = getStringX(expectedString, w);
        const onString = Math.abs(fingerTipX - expectedX) < 40;
        if (!onString) {
          vibrateString(expectedString, false);
          state.lastPluck = { finger: fingerNum, string: expectedString, onString: false, timestamp: Date.now() };
          soundReady = false;
          setTimeout(() => { soundReady = true; }, 400);
          return;
        }
      }

      playSound(fingerNum, qenet);
      state.lastPluck = { finger: fingerNum, string: expectedString, onString: true, timestamp: Date.now() };

      soundReady = false;
      setTimeout(() => { soundReady = true; }, 300);
    }

    if (maxMove < 5) soundReady = true;
  }

  function drawHand(hand, w, h) {
    hand.forEach((lm, i) => {
      const x = lm.x * w;
      const y = lm.y * h;
      ctx.beginPath();
      ctx.arc(x, y, 5, 0, 2 * Math.PI);
      ctx.fillStyle = FINGER_TIPS.includes(i) ? '#00e5ff' : '#00ff88';
      ctx.fill();
    });
    const connections = [
      [0,1],[1,2],[2,3],[3,4],[0,5],[5,6],[6,7],[7,8],[0,9],[9,10],[10,11],[11,12],
      [0,13],[13,14],[14,15],[15,16],[0,17],[17,18],[18,19],[19,20],[5,9],[9,13],[13,17],
    ];
    ctx.strokeStyle = 'rgba(0, 229, 255, 0.4)';
    ctx.lineWidth = 2;
    connections.forEach(([a, b]) => {
      ctx.beginPath();
      ctx.moveTo(hand[a].x * w, hand[a].y * h);
      ctx.lineTo(hand[b].x * w, hand[b].y * h);
      ctx.stroke();
    });
  }

  function drawVirtualStrings(w, h) {
    const time = Date.now();
    const targetString = targetFinger ? FINGER_TO_STRING[targetFinger] : null;
    ALL_STRINGS.forEach((stringNum) => {
      const x = getStringX(stringNum, w);
      const isActive = ACTIVE_STRINGS_REAL.includes(stringNum);
      const isTarget = stringNum === targetString;
      const s = stringStates[stringNum];
      let color, width, opacity;
      if (s.color === 'green') { color = '#00ff88'; width = 3; opacity = 1; }
      else if (s.color === 'red') { color = '#ff1744'; width = 3; opacity = 1; }
      else if (isTarget && isActive) { color = '#00ff88'; width = 2.5; opacity = 0.9; }
      else if (isActive) { color = '#c8a855'; width = 1.5; opacity = 0.7; }
      else { color = '#4a3a20'; width = 1; opacity = 0.3; }

      ctx.beginPath();
      ctx.strokeStyle = color;
      ctx.lineWidth = width;
      ctx.globalAlpha = opacity;
      if (s.vibrating) {
        ctx.moveTo(x, 0);
        for (let y = 0; y < h; y += 8) ctx.lineTo(x + Math.sin(y * 0.04 + time * 0.02) * 6, y);
      } else {
        ctx.moveTo(x, 0);
        ctx.lineTo(x, h);
      }
      ctx.stroke();
      ctx.globalAlpha = 1;

      if (isActive) {
        ctx.save();
        ctx.scale(-1, 1);
        ctx.fillStyle = isTarget ? '#00ff88' : '#888';
        ctx.font = 'bold 13px Arial';
        ctx.fillText(STRING_DISPLAY_NAMES[stringNum], -(x + 6), 22);
        ctx.restore();
      }
    });
  }

  function loop() {
    if (!running) return;
    if (videoEl.readyState >= 2) {
      canvasEl.width = videoEl.videoWidth;
      canvasEl.height = videoEl.videoHeight;
      const results = handLandmarker.detectForVideo(videoEl, performance.now());
      ctx.clearRect(0, 0, canvasEl.width, canvasEl.height);
      if (virtualStrings) drawVirtualStrings(canvasEl.width, canvasEl.height);

      if (results.landmarks && results.landmarks.length > 0) {
        currentHand = results.landmarks[0];
        state.handVisible = true;
        drawHand(currentHand, canvasEl.width, canvasEl.height);
        processMovement(currentHand, canvasEl.width, canvasEl.height);
      } else {
        currentHand = null;
        state.handVisible = false;
      }
    }
    rafId = requestAnimationFrame(loop);
  }

  function setQenet(q) { qenet = q; }
  function setVirtualStrings(v) { virtualStrings = v; }
  function setTargetFinger(f) { targetFinger = f; }

  function captureCalibration() {
    if (!currentHand || !canvasEl) return false;
    const w = canvasEl.width;
    const positions = {};
    ACTIVE_STRINGS_REAL.forEach((s) => { positions[s] = currentHand[STRING_TO_LANDMARK[s]].x * w; });
    ALL_STRINGS.forEach((s) => {
      if (!ACTIVE_STRINGS_REAL.includes(s)) {
        const sorted = [...ACTIVE_STRINGS_REAL].sort((a, b) => a - b);
        for (let i = 0; i < sorted.length - 1; i++) {
          const s1 = sorted[i], s2 = sorted[i + 1];
          if (s > s1 && s < s2) {
            const ratio = (s - s1) / (s2 - s1);
            positions[s] = positions[s1] + ratio * (positions[s2] - positions[s1]);
          }
        }
        if (s < sorted[0]) positions[s] = positions[sorted[0]] - 30;
        if (s > sorted[sorted.length - 1]) positions[s] = positions[sorted[sorted.length - 1]] + 30;
      }
    });
    localStorage.setItem(CALIBRATION_KEY, JSON.stringify(positions));
    stringPositions = positions;
    return true;
  }

  function clearCalibration() {
    localStorage.removeItem(CALIBRATION_KEY);
    stringPositions = null;
  }

  function stop() {
    running = false;
    if (rafId) cancelAnimationFrame(rafId);
    if (stream) stream.getTracks().forEach((t) => t.stop());
    state.ready = false;
    state.cameraReady = false;
    state.handVisible = false;
  }

  function getState() { return JSON.stringify(state); }

  return { start, stop, setQenet, setVirtualStrings, setTargetFinger, captureCalibration, clearCalibration, getState };
})();