# References:
# https://github.com/anibali/docker-pytorch/blob/master/cuda-10.0/Dockerfile
# https://github.com/pypa/pipenv/blob/master/Dockerfile

FROM nvidia/cuda:10.0-base-ubuntu18.04

# Install some basic utilities
RUN apt-get update \
    && apt-get install -y \
    curl \
    ca-certificates \
    sudo \
    git \
    bzip2 \
    libx11-6 \
    libffi-dev \
    software-properties-common \
    && add-apt-repository ppa:jonathonf/python-3.7 \
    && rm -rf /var/lib/apt/lists/*

# Install Python3.6
RUN apt-get update \
    && apt-get install -y \
    python3.7 \
    python3.7-dev \
    python3-pip

# Add backwards compatibility
RUN rm -rf /usr/bin/python3 && ln /usr/bin/python3.7 /usr/bin/python3

# Set env variables
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN pip3 install pipenv

# Create a working directory
RUN mkdir /app
WORKDIR /app

ADD notebook/ notebook/

# Adding Pipfiles
COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock

# Install dependencies
RUN set -ex && pipenv sync --dev

# Install Jupyter Black
RUN pipenv run jupyter nbextension install https://github.com/drillan/jupyter-black/archive/master.zip --user \
    && pipenv run jupyter nbextension enable jupyter-black-master/jupyter-black

# Install Jupyter Isort
RUN pipenv run jupyter nbextension install https://github.com/benjaminabel/jupyter-isort/archive/master.zip --user \
    && pipenv run jupyter nbextension enable jupyter-isort-master/jupyter-isort