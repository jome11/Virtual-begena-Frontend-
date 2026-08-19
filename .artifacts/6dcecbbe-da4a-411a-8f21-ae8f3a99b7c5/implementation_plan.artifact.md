# Implementation Plan - 3D Tuning Viewer Frontend Integration

This plan integrates a 3D tuning viewer into the Flutter app, utilizing Three.js and the previously implemented hand-tracking logic. It involves setting up assets, web-side Three.js infrastructure, and Dart interop layers.

## User Review Required

> [!IMPORTANT]
> The `tuningViewer.start` implementation in `tuning_viewer.js` will need to be fleshed out to initialize the Three.js scene and load the `Gebena.glb` model. I will provide a robust boilerplate that includes the previously provided pinch/rotation logic.

> [!WARNING]
> Ensure that `assets/models/Gebena.glb` is placed in the project directory before building, as the `pubspec.yaml` will now expect it.

## Proposed Changes

### Assets & Configuration
#### [MODIFY] [pubspec.yaml](file:///C:/Users/PAVILION/Desktop/virtual_begena/pubspec.yaml)
- Add `assets/models/` to the assets section to bundle 3D models.

### Web Infrastructure
#### [MODIFY] [index.html](file:///C:/Users/PAVILION/Desktop/virtual_begena/web/index.html)
- Replace the simple Three.js script tag with an `importmap` for Three.js and its addons.
- Change `tuning_viewer.js` to a module script.

#### [MODIFY] [tuning_viewer.js](file:///C:/Users/PAVILION/Desktop/virtual_begena/web/js/tuning_viewer.js)
- Refactor as an ES6 module.
- Implement the `window.tuningViewer` API:
    - `start(containerId)`: Initializes Three.js scene, camera, renderer, and lighting. Loads the GLB model.
    - `rotatePeg(name, radians)`: Programmatically rotate a specific peg.
    - `getStateJson()`: Returns internal state (e.g., current rotations).
- Integrate `updateFromHand()` into the animation loop.

### Dart Interop & Platform View
#### [NEW] [tuning_view_registrar.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/core/services/js/tuning_view_registrar.dart)
- Register the `begena-tuning-viewer` platform view factory.

#### [NEW] [tuning_viewer_interop.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/core/services/js/tuning_viewer_interop.dart)
- Define external JS functions for `start`, `rotatePeg`, and `getStateJson`.

### UI Components
#### [NEW] [tuning_viewer.dart](file:///C:/Users/PAVILION/Desktop/virtual_begena/lib/shared/widgets/tuning_viewer.dart)
- Create a `StatefulWidget` that displays the 3D viewer using `HtmlElementView` and initializes the JS side in `initState`.

## Verification Plan

### Automated Tests
- N/A (UI and 3D rendering require browser interaction).

### Manual Verification
- Verify that the 3D container appears in the Flutter app.
- Check browser logs to confirm `Three.js` and `GLTFLoader` are loading without errors.
- Confirm the `Gebena.glb` model is rendered (requires the model file).
- Test that hand gestures still influence peg rotation via the `updateFromHand` loop inside the module.
