## All Jupyter Notebook Assets

Jupyter Notebook is used to run all examples and exercises.
Jupyter is run in Docker with all dependencies installed.

### Build

```bash
./build.sh
```

This should build the Docker Image `geopython/geopython-workshop:latest`.

### Run

Preferably using Docker Compose with Volume Mapping for Notebooks
and Data. See [docker-compose.yml](../docker-compose.yml).

To run standalone from within this directory:

```bash
docker run -it -p 8888:8888 -v $(pwd)/content:/jupyter/content geopython/geopython-workshop:latest
```

This applies Docker volume mapping for the workshop content contained under `content`.

Look into the output logging and paste the URL with the token like:
http://127.0.0.1:8888/?token=e72ed792ff1d9d90058a7b7443f1ff88f3b12384f721dabe
in your browser.
