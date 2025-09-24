# Menggunakan base image Ubuntu 22.04
FROM ubuntu:22.04

# Menghindari interaktif prompt saat instalasi package
ENV DEBIAN_FRONTEND=noninteractive

# Update package list dan instal paket dasar
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Command default saat container dijalankan
CMD ["/bin/bash"]
