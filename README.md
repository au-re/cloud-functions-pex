**DEPRECATED** you can now [run python natively](https://cloud.google.com/functions/docs/concepts/python-runtime) on cloud functions.

# cloud-functions-pex

**Easily build [Python Executables](https://github.com/pantsbuild/pex) that you can run on [google-cloud-functions](https://cloud.google.com/functions/).**

It turns out that running python code with dependencies like sklearn and scipy on google-cloud-functions is not so easy! After a lot of trial and error I built this docker image to take care of all this. With it you can generate a python executable with all the dependencies you need to run your code on cloud functions.

You can find the image on [dockerhub](https://hub.docker.com/r/aurefranky/google-appengine-pex/).

## Building the executable

For this to work, you will need [docker](https://www.docker.com/) installed on your machine. You can find out how to install it [here](https://docs.docker.com/install/).
You will also need a `requirements.txt` file at the root of your project with all your dependencies. e.g.

requirements.txt
```
numpy
scipy
scikit-learn
```

That's all! Now simply navigate to the root of your project and run

```sh
docker run -v $(pwd):/app/shared -it aurefranky/google-appengine-pex
```

A `env.pex` file should have been generated.

## Running your python code on cloud functions

Add your python script and the pex file to your cloud function project.

```
index.js
myscript.py
env.pex
```

You can then run your python script from within node like so:

index.js
```js
const functions = require('firebase-functions');
const { execFile } = require('child_process');
const path = require('path');

exports.pexDemo = functions.https.onRequest((req, res) => {
  execFile(path.join(__dirname, "./env.pex"), [path.join(__dirname, "./myscript.py")],
    (error, stdout, stderr) => {
      if (error) return res.status(500).send({ error });
      return res.status(200).send({ done: stdout })
    });
});
```

Done!

## Limitations

Remember that you are limited to **100MB** when uploading to cloud functions. The resulting size for the sklearn executable for example is **53MB**.

If you encounter issues, you might have to upgrade your cloud function to use more than the default 256MB of ram.

## License

[MIT](https://github.com/au-re/cloud-functions-pex/blob/master/LICENSE)

