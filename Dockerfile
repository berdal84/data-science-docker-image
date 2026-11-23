#
# Docker image to be used in my Nextflow pipelines
#
# Note: The day you rebuild this image, you have to:
#       - find the latest sha from debian:stable-slim
#

FROM debian:stable-slim@sha256:fbfb4059d2127120aa05b6e6064523d2102552f0cf0026ddf0701c12f1f8f3e0

# Update System
RUN apt-get update -y \
 && apt-get upgrade -y \
 && apt-get install curl -y

# Install Conda
RUN curl -fSL --retry 3 \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
    -o /tmp/miniconda.sh \
 && bash /tmp/miniconda.sh -b -p /opt/conda \
 && rm /tmp/miniconda.sh
ENV PATH="/opt/conda/bin:$PATH"

# Install Environment
RUN conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main \
 && conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r
COPY environment.yml /tmp/environment.yml
RUN conda env create -f /tmp/environment.yml

# Activate Environment
RUN conda activate data-science-env