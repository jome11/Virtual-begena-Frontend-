/*!
 * begena-viewer.js  v1.0.0
 * Interactive 3D viewer for the Begena (በገና) model. Click a part -> highlight + callback.
 *
 * Requires (global, loaded BEFORE this file), all pinned to three.js r128 / 0.128.0:
 *   build/three.min.js
 *   examples/js/loaders/GLTFLoader.js
 *   examples/js/controls/OrbitControls.js
 *
 * Usage:
 *   var viewer = BegenaViewer.mount({
 *     container: document.getElementById('stage'),   // must have a width and a height (CSS)
 *     modelUrl:  '/assets/Gebena.glb',
 *     parts:     [{id:'kenber', name:'ቀንበር'}, ...],  // used for hover tooltips (optional)
 *     onSelect:  function(id, info){ ... },             // user clicked a part on the model
 *     onHover:   function(id){ ... },                   // optional
 *     onReady:   function(){ ... },                     // optional
 *     onError:   function(err){ ... }                   // optional
 *   });
 *   viewer.select('strings');   // highlight + fly to a part (does NOT fire onSelect)
 *   viewer.select(null);        // clear highlight + reset camera
 *   viewer.setView('front'|'side'|'back'|'home');
 *   viewer.destroy();           // remove canvas, listeners, free GPU memory
 *
 * Part ids: kenber, get, mekagn, pillarR, pillarL, strings, gebete, mewetcheria, enzira
 * (see README.md -> "How parts are detected").
 */
(function (global) {
  'use strict';

  /* ------------------------------------------------------------------
     Part-detection settings. Model coordinates (glTF units, Y up, front = +Z).
     The model body is ONE merged mesh, so parts are found by position.
     If the model file is re-exported with different geometry, re-check these.
     ------------------------------------------------------------------ */
  var CFG = {
    boxTop:        2.65,   // below this Y = sound box (ገበቴ) zone
    boxTopBlend:   2.95,   // 2.65..2.95: flat/large triangles still belong to the box
    frontPlateZ:   0.78,   // box triangles in FRONT of this Z are add-on pieces
    anchorMaxY:    0.6,    // add-on pieces below this Y = መወጠሪያ, above = እንዚራ
    crossbarMinY:  8.35,   // from here up = ቀንበር
    ornamentMinY:  8.6,    // from here up = ጌጥ (መስቀል)
    pillarSplitX:  2.15,   // X < split = pillarR ("ቀኝ ምሰሶ"), X >= split = pillarL ("ግራ ምሰሶ")
    moverMinY:     8.36,   // hits on the string mesh above this Y count as መቃኛ
    // invisible, easier-to-tap boxes for thin parts: [x0,x1, y0,y1, z0,z1]
    stringsHit:    [1.68, 2.68, 2.9, 8.32, 0.66, 0.98],
    moversHit:     [1.66, 2.68, 8.34, 8.64, 0.66, 0.86],
    bodyMaterial:    'Procedural Wood.001', // material name of the main wood body
    stringsMaterial: 'Material.001'         // material name of the black string mesh
  };

  var HIGHLIGHT = 0xffbf3c;

  function mount(opts) {
    var THREE = global.THREE;
    if (!THREE || !THREE.GLTFLoader || !THREE.OrbitControls) {
      var e = new Error('BegenaViewer: three.js, GLTFLoader and OrbitControls must be loaded first.');
      if (opts.onError) opts.onError(e); else throw e;
      return noopApi();
    }
    var container = opts.container;
    if (getComputedStyle(container).position === 'static') container.style.position = 'relative';
    var reduced = global.matchMedia && global.matchMedia('(prefers-reduced-motion: reduce)').matches;

    var names = {};
    (opts.parts || []).forEach(function (p) { names[p.id] = p.name; });

    var canvas = document.createElement('canvas'); canvas.className = 'bgv-canvas'; container.appendChild(canvas);
    var tip = document.createElement('div'); tip.className = 'bgv-tip'; tip.hidden = true; container.appendChild(tip);

    var renderer;
    try { renderer = new THREE.WebGLRenderer({ canvas: canvas, antialias: true, alpha: true }); }
    catch (err) { canvas.remove(); tip.remove(); if (opts.onError) opts.onError(err); return noopApi(); }
    renderer.setPixelRatio(Math.min(global.devicePixelRatio || 1, 2));
    renderer.outputEncoding = THREE.sRGBEncoding;

    var scene = new THREE.Scene();
    var camera = new THREE.PerspectiveCamera(32, 1, 0.1, 200);
    var controls = new THREE.OrbitControls(camera, canvas);
    controls.enableDamping = true; controls.dampingFactor = 0.08;
    controls.minDistance = 2.5; controls.maxDistance = 40; controls.screenSpacePanning = true;

    scene.add(new THREE.HemisphereLight(0xffffff, 0x556070, 0.95));
    var key = new THREE.DirectionalLight(0xfff0dc, 1.15); key.position.set(6, 12, 14); scene.add(key);
    var back = new THREE.DirectionalLight(0xdfe8ff, 0.9); back.position.set(-6, 8, -14); scene.add(back);
    var fill = new THREE.DirectionalLight(0xffffff, 0.35); fill.position.set(-10, 2, 6); scene.add(fill);
    var root = new THREE.Group(); scene.add(root);

    var state = { ready: false, destroyed: false, pending: undefined, current: null, hover: null,
                  tween: null, defDist: 20, raf: 0 };
    var internals = {};  // filled in setup()

    new THREE.GLTFLoader().load(opts.modelUrl, function (gltf) {
      if (state.destroyed) return;
      try { setup(gltf); } catch (err) { console.error(err); if (opts.onError) opts.onError(err); }
    }, undefined, function (err) { console.error(err); if (opts.onError) opts.onError(err); });

    function setup(gltf) {
      var model = gltf.scene; model.updateMatrixWorld(true);
      var body = null, strings = null, movers = [];
      model.traverse(function (o) {
        if (!o.isMesh) return;
        var mn = o.material && o.material.name;
        if (mn === CFG.bodyMaterial) body = o;
        else if (mn === CFG.stringsMaterial) strings = o;
        else movers.push(o);
      });
      if (!body) throw new Error('BegenaViewer: body mesh not found (material "' + CFG.bodyMaterial + '").');

      function classify(c, n, area) {
        if (c.y < CFG.boxTop) { if (c.z > CFG.frontPlateZ) return c.y < CFG.anchorMaxY ? 'mewetcheria' : 'enzira'; return 'gebete'; }
        if (c.y < CFG.boxTopBlend && (Math.abs(n.y) > 0.8 || area > 0.02)) return 'gebete';
        if (c.y >= CFG.ornamentMinY) return 'get';
        if (c.y >= CFG.crossbarMinY) return 'kenber';
        return c.x < CFG.pillarSplitX ? 'pillarR' : 'pillarL';
      }
      var g = body.geometry, pos = g.attributes.position, idx = g.index.array, nTri = idx.length / 3;
      var triPart = new Array(nTri), buckets = {};
      var v = [new THREE.Vector3(), new THREE.Vector3(), new THREE.Vector3()];
      var c = new THREE.Vector3(), e1 = new THREE.Vector3(), e2 = new THREE.Vector3(), n = new THREE.Vector3();
      for (var t = 0; t < nTri; t++) {
        for (var k = 0; k < 3; k++) v[k].fromBufferAttribute(pos, idx[3 * t + k]).applyMatrix4(body.matrixWorld);
        c.copy(v[0]).add(v[1]).add(v[2]).multiplyScalar(1 / 3);
        e1.subVectors(v[1], v[0]); e2.subVectors(v[2], v[0]); n.crossVectors(e1, e2);
        var area = n.length() / 2; n.normalize();
        var pid = classify(c, n, area); triPart[t] = pid;
        (buckets[pid] = buckets[pid] || []).push(v[0].x, v[0].y, v[0].z, v[1].x, v[1].y, v[1].z, v[2].x, v[2].y, v[2].z);
      }
      root.add(model);

      var overlays = {};
      function overlayMat() {
        return new THREE.MeshBasicMaterial({ color: HIGHLIGHT, transparent: true, opacity: 0, side: THREE.DoubleSide,
          depthWrite: false, polygonOffset: true, polygonOffsetFactor: -2, polygonOffsetUnits: -2 });
      }
      function addOverlay(id, geoms) {
        var grp = new THREE.Group(), mats = [];
        geoms.forEach(function (geo) { var m = overlayMat(); mats.push(m); grp.add(new THREE.Mesh(geo, m)); });
        grp.visible = false; root.add(grp); overlays[id] = { group: grp, mats: mats };
      }
      Object.keys(buckets).forEach(function (id) {
        var geo = new THREE.BufferGeometry();
        geo.setAttribute('position', new THREE.BufferAttribute(new Float32Array(buckets[id]), 3));
        addOverlay(id, [geo]);
      });
      if (strings) addOverlay('strings', [strings.geometry.clone().applyMatrix4(strings.matrixWorld)]);
      addOverlay('mekagn', movers.map(function (m) { return m.geometry.clone().applyMatrix4(m.matrixWorld); }));

      var proxies = [];
      function proxy(id, b) {
        var geo = new THREE.BoxGeometry(b[1] - b[0], b[3] - b[2], b[5] - b[4]);
        var m = new THREE.MeshBasicMaterial({ color: HIGHLIGHT, transparent: true, opacity: 0, depthWrite: false });
        var mesh = new THREE.Mesh(geo, m); mesh.position.set((b[0] + b[1]) / 2, (b[2] + b[3]) / 2, (b[4] + b[5]) / 2);
        mesh.userData.part = id; root.add(mesh); proxies.push(mesh); overlays[id].glow = m;
      }
      proxy('strings', CFG.stringsHit); proxy('mekagn', CFG.moversHit);

      var box = new THREE.Box3().setFromObject(model);
      var center = box.getCenter(new THREE.Vector3()), size = box.getSize(new THREE.Vector3());
      root.position.copy(center).multiplyScalar(-1); root.updateMatrixWorld(true);

      var fov = THREE.MathUtils.degToRad(camera.fov);
      function fitDist() {
        var asp = camera.aspect || 1;
        var dH = (size.y / 2) / Math.tan(fov / 2), dW = (size.x / 2) / (Math.tan(fov / 2) * asp);
        return Math.max(dH, dW) * 1.18 + size.z;
      }
      var VIEWS = { front: [0, 0], side: [Math.PI / 2, 0], back: [Math.PI, 0], home: [0.5, 0.14] };
      function dirFrom(az, el) { return new THREE.Vector3(Math.sin(az) * Math.cos(el), Math.sin(el), Math.cos(az) * Math.cos(el)); }

      function animateTo(p, target) {
        if (reduced) { camera.position.copy(p); controls.target.copy(target); controls.update(); state.tween = null; return; }
        state.tween = { t0: performance.now(), dur: 750, p0: camera.position.clone(), a0: controls.target.clone(), p1: p, a1: target };
      }
      controls.addEventListener('start', function () { state.tween = null; });

      function resize() {
        var w = container.clientWidth, h = container.clientHeight; if (!w || !h) return;
        renderer.setSize(w, h, false); camera.aspect = w / h; camera.updateProjectionMatrix(); state.defDist = fitDist();
      }
      resize();
      var ro = (typeof ResizeObserver !== 'undefined') ? new ResizeObserver(resize) : null;
      if (ro) ro.observe(container); else global.addEventListener('resize', resize);
      camera.position.copy(dirFrom(VIEWS.home[0], VIEWS.home[1]).multiplyScalar(state.defDist));
      controls.target.set(0, 0, 0); controls.update();

      internals.setView = function (name) {
        var vw = VIEWS[name] || VIEWS.home;
        animateTo(dirFrom(vw[0], vw[1]).multiplyScalar(state.defDist), new THREE.Vector3(0, 0, 0));
      };
      internals.fly = function (id) {
        var ov = overlays[id]; if (!ov) return;
        var b = new THREE.Box3().setFromObject(ov.group); if (b.isEmpty()) return;
        var ctr = b.getCenter(new THREE.Vector3()), r = b.getSize(new THREE.Vector3()).length() / 2;
        var dir = camera.position.clone().sub(controls.target).normalize();
        if (dir.z < 0.35) { dir.z = 0.5; dir.normalize(); }
        var dist = Math.min(Math.max(r * 2.7, 4.5), state.defDist);
        animateTo(ctr.clone().add(dir.multiplyScalar(dist)), ctr);
      };

      /* picking */
      var ray = new THREE.Raycaster(), ndc = new THREE.Vector2(), tmp = new THREE.Vector3();
      var targets = [body].concat(strings ? [strings] : [], movers, proxies);
      function pick(ev) {
        var r = canvas.getBoundingClientRect();
        ndc.set(((ev.clientX - r.left) / r.width) * 2 - 1, -((ev.clientY - r.top) / r.height) * 2 + 1);
        ray.setFromCamera(ndc, camera);
        var hits = ray.intersectObjects(targets, false);
        for (var i = 0; i < hits.length; i++) {
          var h = hits[i], o = h.object, id = null;
          if (o.userData.part) id = o.userData.part;
          else if (o === body) id = triPart[h.faceIndex];
          else if (o === strings) { tmp.copy(h.point); root.worldToLocal(tmp); id = tmp.y > CFG.moverMinY ? 'mekagn' : 'strings'; }
          else id = 'mekagn';
          if (id) return id;
        }
        return null;
      }
      var down = null;
      function onDown(e) { down = { x: e.clientX, y: e.clientY, t: performance.now() }; }
      function onUp(e) {
        if (!down) return;
        var moved = Math.hypot(e.clientX - down.x, e.clientY - down.y), dt = performance.now() - down.t; down = null;
        if (moved < 6 && dt < 600) {
          var id = pick(e);
          if (id) { state.current = id; internals.fly(id); if (opts.onSelect) opts.onSelect(id, { source: 'model' }); }
        }
      }
      function onMove(e) {
        if (e.pointerType !== 'mouse' || e.buttons) { tip.hidden = true; return; }
        var id = pick(e);
        if (id !== state.hover) { state.hover = id; if (opts.onHover) opts.onHover(id); }
        canvas.classList.toggle('bgv-over', !!id);
        if (id) {
          var r = container.getBoundingClientRect();
          tip.textContent = names[id] || id; tip.style.left = (e.clientX - r.left) + 'px'; tip.style.top = (e.clientY - r.top) + 'px'; tip.hidden = false;
        } else tip.hidden = true;
      }
      function onLeave() { state.hover = null; tip.hidden = true; canvas.classList.remove('bgv-over'); }
      canvas.addEventListener('pointerdown', onDown); canvas.addEventListener('pointerup', onUp);
      canvas.addEventListener('pointermove', onMove); canvas.addEventListener('pointerleave', onLeave);

      /* render loop */
      function frame(now) {
        state.raf = requestAnimationFrame(frame);
        var tw = state.tween;
        if (tw) {
          var k = Math.min(1, (now - tw.t0) / tw.dur), e = k < 0.5 ? 4 * k * k * k : 1 - Math.pow(-2 * k + 2, 3) / 2;
          camera.position.lerpVectors(tw.p0, tw.p1, e); controls.target.lerpVectors(tw.a0, tw.a1, e);
          if (k >= 1) state.tween = null;
        }
        controls.update();
        var pulse = reduced ? 0.6 : 0.55 + 0.15 * Math.sin(now / 260);
        Object.keys(overlays).forEach(function (id) {
          var ov = overlays[id], o = 0, gl = 0;
          if (id === state.current) { o = pulse; gl = 0.16; } else if (id === state.hover) { o = 0.35; gl = 0.08; }
          ov.group.visible = o > 0;
          ov.mats.forEach(function (m) { m.opacity = o; });
          if (ov.glow) ov.glow.opacity = gl;
        });
        renderer.render(scene, camera);
      }
      state.raf = requestAnimationFrame(frame);

      internals.dispose = function () {
        cancelAnimationFrame(state.raf);
        if (ro) ro.disconnect(); else global.removeEventListener('resize', resize);
        canvas.removeEventListener('pointerdown', onDown); canvas.removeEventListener('pointerup', onUp);
        canvas.removeEventListener('pointermove', onMove); canvas.removeEventListener('pointerleave', onLeave);
        controls.dispose();
        scene.traverse(function (o) {
          if (o.geometry) o.geometry.dispose();
          if (o.material) { (Array.isArray(o.material) ? o.material : [o.material]).forEach(function (m) {
            for (var key in m) { if (m[key] && m[key].isTexture) m[key].dispose(); } m.dispose(); }); }
        });
      };

      state.ready = true;
      if (state.pending !== undefined) { api.select(state.pending); state.pending = undefined; }
      if (opts.onReady) opts.onReady();
    }

    var api = {
      select: function (id) {
        if (!state.ready) { state.pending = id; return; }
        state.current = id || null;
        if (id) internals.fly(id); else internals.setView('home');
      },
      setView: function (name) { if (state.ready) internals.setView(name); },
      resetView: function () { if (state.ready) internals.setView('home'); },
      destroy: function () {
        state.destroyed = true; cancelAnimationFrame(state.raf);
        if (internals.dispose) internals.dispose();
        renderer.dispose(); canvas.remove(); tip.remove();
      },
      get ready() { return state.ready; }
    };
    return api;
  }

  function noopApi() { return { select: function () {}, setView: function () {}, resetView: function () {}, destroy: function () {}, ready: false }; }

  global.BegenaViewer = { mount: mount, VERSION: '1.0.0', CONFIG: CFG };
})(window);
