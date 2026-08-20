// web/begena_3d.js
window.begena3D = (() => {
  let renderer = null;
  let scene = null;
  let camera = null;
  let canvasEl = null;
  let ready = false;

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

  return { mount, isReady };
})();
