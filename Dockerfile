# Basis Ubuntu 22.04
FROM ubuntu:22.04

# Non-interaktif + runtime Python rapi
ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    JUPYTER_DIR=/workspace

# Paket OS minimal: Python3, pip, tini, curl, CA
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    python3 python3-pip tini curl ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Instal JupyterLab 4 dan Jupyter Server 2
RUN pip3 install --no-cache-dir \
    jupyterlab==4.* \
    jupyter-server==2.*

# Buat user non-root
RUN useradd -m -u 1000 -s /bin/bash app \
 && mkdir -p "${JUPYTER_DIR}" \
 && chown -R app:app "${JUPYTER_DIR}"
USER app

WORKDIR ${JUPYTER_DIR}

# Clever Cloud default HTTP port
EXPOSE 8080

# Gunakan tini sebagai init
ENTRYPOINT ["/usr/bin/tini", "--"]

# Jalankan JupyterLab pada 0.0.0.0:8080
# Token dibaca dari env JUPYTER_TOKEN
CMD ["jupyter", "lab", \
     "--ServerApp.ip=0.0.0.0", \
     "--ServerApp.port=8080", \
     "--ServerApp.root_dir=/workspace", \
     "--ServerApp.base_url=/", \
     "--ServerApp.token=${JUPYTER_TOKEN}"]
     
