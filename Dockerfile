# References:
# https://github.com/anibali/docker-pytorch/blob/master/cuda-10.0/Dockerfile
# https://github.com/pypa/pipenv/blob/master/Dockerfile

FROM nvidia/cuda:10.0-base-ubuntu18.04

# Install Basic Utilities
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

# Add Backwards Compatibility
RUN rm -rf /usr/bin/python3 && ln /usr/bin/python3.7 /usr/bin/python3

# Set Env Variables
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

# Install Pip3 Pipenv
RUN pip3 install pipenv

# Create a working directory
RUN mkdir /app
WORKDIR /app

# Adding Pipfiles
COPY Pipfile Pipfile
COPY Pipfile.lock Pipfile.lock

# Install Dependencies
RUN set -ex && pipenv sync --dev

# Install Jupyter Notebook Extensions
RUN pipenv run jupyter contrib nbextension install --user \
    && pipenv run jupyter nbextensions_configurator enable --user

# Install Jupyter Black
RUN pipenv run jupyter nbextension install https://github.com/drillan/jupyter-black/archive/master.zip --user \
    && pipenv run jupyter nbextension enable jupyter-black-master/jupyter-black

# Install Jupyter Isort
RUN pipenv run jupyter nbextension install https://github.com/benjaminabel/jupyter-isort/archive/master.zip --user \
    && pipenv run jupyter nbextension enable jupyter-isort-master/jupyter-isort

# # Install Jupyter Vim
RUN mkdir -p $(pipenv run jupyter --data-dir)/nbextensions \
    && cd $(pipenv run jupyter --data-dir)/nbextensions \ 
    && git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding \
    && chmod -R go-w vim_binding 
RUN pipenv run jupyter nbextension enable vim_binding/vim_binding


## Enable Nbextensions (Reference URL: https://qiita.com/simonritchie/items/88161c806197a0b84174)

# Table Beautifier
RUN pipenv run jupyter nbextension enable table_beautifier/main

# Table of Contents
RUN pipenv run jupyter nbextension enable toc2/main

# Toggle all line numbers
RUN pipenv run jupyter nbextension enable toggle_all_line_numbers/main

# AutoSaveTime
RUN pipenv run jupyter nbextension enable autosavetime/main

# Collapsible Headings
RUN pipenv run jupyter nbextension enable collapsible_headings/main

# Execute Time
RUN pipenv run jupyter nbextension enable execute_time/ExecuteTime

# Codefolding
RUN pipenv run jupyter nbextension enable codefolding/main

# Notify
RUN pipenv run jupyter nbextension enable notify/notify

# Change Theme
RUN pipenv run jt -t chesterish -T -f roboto -fs 9 -tf merriserif -tfs 11 -nf ptsans -nfs 11 -dfs 8 -ofs 8 \
    && sed -i '1s/^/.edit_mode .cell.selected .CodeMirror-focused:not(.cm-fat-cursor) { background-color: #1a0000 !important; }\n /' /root/.jupyter/custom/custom.css \
    && sed -i '1s/^/.edit_mode .cell.selected .CodeMirror-focused.cm-fat-cursor { background-color: #1a0000 !important; }\n /' /root/.jupyter/custom/custom.css

# Set Configuration Password
RUN pipenv run jupyter notebook --generate-config
