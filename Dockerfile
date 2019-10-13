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

# Install Jupyter Notebook Extensions
RUN pipenv install jupyter-contrib-nbextensions \
    && pipenv install jupyter-nbextensions-configurator \
    && pipenv run jupyter contrib nbextension install --user \
    && pipenv run jupyter nbextensions_configurator enable --user

# Install Jupyter Black
RUN pipenv run jupyter nbextension install https://github.com/drillan/jupyter-black/archive/master.zip --user \
    && pipenv run jupyter nbextension enable jupyter-black-master/jupyter-black

# Install Jupyter Isort
RUN pipenv run jupyter nbextension install https://github.com/benjaminabel/jupyter-isort/archive/master.zip --user \
    && pipenv run jupyter nbextension enable jupyter-isort-master/jupyter-isort

# Install Jupyter Vim
RUN mkdir -p $(pipenv run jupyter --data-dir)/nbextensions \
    && cd $(pipenv run jupyter --data-dir)/nbextensions \
    && git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding \
    && pipenv run jupyter nbextension enable vim_binding/vim_binding

# Change theme
RUN pipenv install jupyterthemes \
    && jt -t chesterish -T -f roboto -fs 9 -tf merriserif -tfs 11 -nf ptsans -nfs 11 -dfs 8 -ofs 8

# set password
RUN pipenv run jupyter notebook --generate-config
RUN echo "c.NotebookApp.password='sha1:de50b38803a5:d854c89d71dca9a5810e16398ff0c00dbf950b20'">>/root/.jupyter/jupyter_notebook_config.py

CMD pipenv run jupyter notebook --ip 0.0.0.0 --no-browser --allow-root

