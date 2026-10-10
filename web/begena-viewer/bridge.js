// web/begena-viewer/bridge.js
window.begenaBridge = (() => {
  let viewer = null;
  let partsData = null;

  const state = {
    ready: false,
    error: null,
    selectedId: null, // last part tapped on the 3D model
    hoveredId: null,
  };

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
          reject(new Error(`begena-viewer: element #${id} never appeared`));
        }
      }, 50);
    });
  }

  async function mount(containerId, modelUrl, partsUrl) {
    try {
      const container = await waitForElement(containerId);

      const res = await fetch(partsUrl);
      partsData = await res.json();
      const parts = (partsData.parts || [])
        .filter((p) => p.onModel)
        .map((p) => ({ id: p.id, name: p.name }));

      viewer = window.BegenaViewer.mount({
        container,
        modelUrl,
        parts,
        onSelect: (id) => { state.selectedId = id; },
        onHover: (id) => { state.hoveredId = id; },
        onReady: () => { state.ready = true; },
        onError: (err) => { state.error = String((err && err.message) || err); },
      });
    } catch (err) {
      state.error = String((err && err.message) || err);
    }
  }

  function select(id) { if (viewer) viewer.select(id || null); }
  function setView(name) { if (viewer) viewer.setView(name); }
  function destroy() {
    if (viewer) { viewer.destroy(); viewer = null; }
    state.ready = false;
  }
  function getState() { return JSON.stringify(state); }
  function getPartsJson() { return partsData ? JSON.stringify(partsData) : ''; }

  return { mount, select, setView, destroy, getState, getPartsJson };
})();
