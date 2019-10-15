# url: https://github.com/Kaggle/docker-python
FROM gcr.io/kaggle-images/python:v56

WORKDIR /app

COPY ./requirements.txt .

# ライブラリの追加インストール
RUN pip install -U pip \
    && pip install fastprogress japanize-matplotlib \
    && pip install -r ./requirements.txt 

# jupyter-notebook-extensions のインストール
RUN pip install jupyter_contrib_nbextensions \
    && jupyter contrib nbextension install --user \
    && jupyter nbextension enable codefolding/main

# jupyterlabをインストール
RUN pip install --upgrade pip && pip install jupyterlab \
    && jupyter serverextension enable --py jupyterlab

# jupyter-vimの設定
RUN mkdir -p $(jupyter --data-dir)/nbextensions \
    && cd $(jupyter --data-dir)/nbextensions \
    && git clone https://github.com/lambdalisue/jupyter-vim-binding vim_binding \
    && jupyter nbextension enable vim_binding/vim_binding

# Install Jupyter Black
RUN jupyter nbextension install https://github.com/drillan/jupyter-black/archive/master.zip --user \
    && jupyter nbextension enable jupyter-black-master/jupyter-black

# Install Jupyter Isort
RUN jupyter nbextension install https://github.com/benjaminabel/jupyter-isort/archive/master.zip --user \
    && jupyter nbextension enable jupyter-isort-master/jupyter-isort

# Mecabのインストール
RUN apt-get update \
    && apt-get install -y mecab \
    && apt-get install -y libmecab-dev \
    && apt-get install -y mecab-ipadic-utf8 \
    && apt-get install -y git \
    && apt-get install -y make \
    && apt-get install -y curl \
    && apt-get install -y xz-utils \
    && apt-get install -y file \
    && apt-get install -y sudo \
    && apt-get install -y wget

RUN git clone --depth 1 https://github.com/neologd/mecab-ipadic-neologd.git \
    && cd mecab-ipadic-neologd \
    && bin/install-mecab-ipadic-neologd -n -y

RUN apt-get install -y software-properties-common vim

# Change Theme
RUN jt -t chesterish -T -f roboto -fs 9 -tf merriserif -tfs 11 -nf ptsans -nfs 11 -dfs 8 -ofs 8 \
    && sed -i '1s/^/.edit_mode .cell.selected .CodeMirror-focused:not(.cm-fat-cursor) { background-color: #1a0000 !important; }\n /' /root/.jupyter/custom/custom.css \
    && sed -i '1s/^/.edit_mode .cell.selected .CodeMirror-focused.cm-fat-cursor { background-color: #1a0000 !important; }\n /' /root/.jupyter/custom/custom.css

# Set Configuration Password
RUN jupyter notebook --generate-config
RUN echo "c.NotebookApp.password='sha1:de50b38803a5:d854c89d71dca9a5810e16398ff0c00dbf950b20'">>/root/.jupyter/jupyter_notebook_config.py

# Jupyter Notebook Command
CMD jupyter notebook --ip 0.0.0.0 --no-browser --allow-root