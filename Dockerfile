# Menggunakan base image Ubuntu 22.04
FROM ubuntu:22.04

# Menghindari interaktif prompt saat instalasi package
ENV DEBIAN_FRONTEND=noninteractive

# Update package list dan instal Python dan dependensi
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    build-essential \
    curl \
    wget \
    git \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip dan instal Jupyter
RUN pip3 install --upgrade pip
RUN pip3 install jupyter jupyterlab

# Buat direktori untuk notebook
WORKDIR /home/jupyter

# Konfigurasi Jupyter untuk mengizinkan akses remote dan token
RUN jupyter lab --generate-config
RUN echo "c.ServerApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_lab_config.py
RUN echo "c.ServerApp.port = 8888" >> ~/.jupyter/jupyter_lab_config.py
RUN echo "c.ServerApp.open_browser = False" >> ~/.jupyter/jupyter_lab_config.py
RUN echo "c.ServerApp.allow_root = True" >> ~/.jupyter/jupyter_lab_config.py
RUN echo "c.ServerApp.token = ''" >> ~/.jupyter/jupyter_lab_config.py
RUN echo "c.ServerApp.password = ''" >> ~/.jupyter/jupyter_lab_config.py

# Expose port Jupyter
EXPOSE 8888

# Command untuk menjalankan Jupyter Lab saat container dijalankan
CMD ["jupyter", "lab", "--allow-root", "--no-browser", "--ip=0.0.0.0", "--port=8888"]
