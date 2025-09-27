FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    JUPYTER_DIR=/workspace

# Paket dasar
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    python3 python3-pip tini curl ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# JupyterLab 4 + Jupyter Server 2
RUN pip3 install --no-cache-dir \
    jupyterlab==4.* \
    jupyter-server==2.*

# User non-root
RUN useradd -m -u 1000 -s /bin/bash app \
 && mkdir -p "${JUPYTER_DIR}" \
 && chown -R app:app "${JUPYTER_DIR}"
USER app

WORKDIR ${JUPYTER_DIR}

# Clever Cloud akan memeriksa layanan pada 8080
EXPOSE 8080

# tini sebagai init
ENTRYPOINT ["/usr/bin/tini", "--"]

# Jalankan tanpa token dan tanpa password
CMD ["jupyter", "lab", \
     "--ServerApp.ip=0.0.0.0", \
     "--ServerApp.port=8080", \
     "--ServerApp.root_dir=/workspace", \
     "--ServerApp.base_url=/", \
     "--ServerApp.token=''", \
     "--ServerApp.password=''"]
     
