# AI Diffraction
## Crystal-to-Diffraction Pattern via Machine Learning


*by Joe Webb*

ai-diffraction is a machine learning approach to diffraction patterns. It serves as a proof of concept that the field of microscopy can be greatly aided by the use of machine learning: electron diffraction experiments are expensive, existing computational methods are time-consuming, and machine learning has the benefit of being neither.


<html>
  <header>
    <script>
        const ort = require('onnxruntime-web');
        // create an inference session, using WebGL backend. (default is 'wasm')
        const session = await ort.InferenceSession.create('./assets/model.onnx', { executionProviders: ['webgl'] });
        …
        // feed inputs and run
        const results = await session.run(feeds);
    </script>
  </body>
</html>