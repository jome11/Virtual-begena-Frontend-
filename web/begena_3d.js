// web/begena_3d.js
window.begena3D = (() => {
  let renderer = null;
  let scene = null;
  let camera = null;
  let canvasEl = null;
  let ready = false;

  const strings = {};
  let animating = false;

  function tick() {
    let active = false;
    const now = performance.now();
    for (const k in strings) {
      const s = strings[k];
      if (s.glow > 0.02) {
        s.glow *= 0.94;
        s.mats.forEach((m) => { m.emissiveIntensity = s.glow * 2.2; });
        s.mesh.position.x = s.base.x + Math.sin(now / 18) * 0.012 * s.glow;
        active = true;
      } else if (s.glow !== 0) {
        s.glow = 0;
        s.mats.forEach((m) => { m.emissiveIntensity = 0; });
        s.mesh.position.copy(s.base);
      }
    }
    renderer.render(scene, camera);
    if (active) requestAnimationFrame(tick);
    else animating = false;
  }

  function pluck(n) {
    const s = strings[n];
    if (!s) return;
    s.glow = 1;
    if (!animating) {
      animating = true;
      requestAnimationFrame(tick);
    }
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
          reject(new Error(`begena3D: element #${id} never appeared`));
        }
      }, 50);
    });
  }

  async function mount(canvasElementId) {
    canvasEl = await waitForElement(canvasElementId);
    const width = canvasEl.clientWidth || 300;
    const height = canvasEl.clientHeight || 300;

    renderer = new THREE.WebGLRenderer({ canvas: canvasEl, antialias: true, alpha: true });
    renderer.setPixelRatio(window.devicePixelRatio || 1);
    renderer.setSize(width, height, false);
    renderer.setClearColor(0x000000, 0);

    scene = new THREE.Scene();
    camera = new THREE.PerspectiveCamera(35, width / height, 0.1, 100);
    camera.position.set(0, 0.4, 6);
    camera.lookAt(0, 0, 0);

    scene.add(new THREE.HemisphereLight(0xffffff, 0x333333, 1.3));
    const dir = new THREE.DirectionalLight(0xffffff, 1.6);
    dir.position.set(3, 5, 4);
    scene.add(dir);

    const loader = new THREE.GLTFLoader();
    await new Promise((resolve, reject) => {
      loader.load(
        'models/Gebena.glb',
        (gltf) => {
          const gltfScene = gltf.scene;
          const box = new THREE.Box3().setFromObject(gltfScene);
          const size = box.getSize(new THREE.Vector3());
          const center = box.getCenter(new THREE.Vector3());
          const maxDim = Math.max(size.x, size.y, size.z) || 1;
          const scale = 4 / maxDim;
          gltfScene.scale.setScalar(scale);
          gltfScene.position.sub(center.multiplyScalar(scale));
          scene.add(gltfScene);

          gltfScene.traverse((o) => {
            if (!o.isMesh || !/^(0[1-9]|10)$/.test(o.name)) return;
            const mats = (Array.isArray(o.material) ? o.material : [o.material]).map((m) => {
              const c = m.clone();
              c.emissive = new THREE.Color(0x60a5fa);
              c.emissiveIntensity = 0;
              return c;
            });
            o.material = Array.isArray(o.material) ? mats : mats[0];
            strings[parseInt(o.name, 10)] = { mesh: o, mats, glow: 0, base: o.position.clone() };
          });

          resolve();
        },
        undefined,
        reject,
      );
    });

    ready = true;
    renderer.render(scene, camera);
  }

  function isReady() {
    return ready;
  }

  return { mount, isReady, pluck };
})();
