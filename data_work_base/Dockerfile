ARG BASE_CONTAINER=debian@sha256:9490c476443a3869e39c2897fa66c91daf5dcbbfca53c976dac7bbdc45775b28
FROM $BASE_CONTAINER
LABEL author="anosillus"

USER root

RUN apt-get update --fix-missing && apt-get -yq dist-upgrade && \
    apt-get install -y \
      bzip2 \
      ca-certificates \
      fonts-liberation \
      git \
      libglib2.0-0\
      libsm6 \
      libxext6 \
      libxrender1 \
      locales \
      mercurial \
      subversion \
      sudo \
      wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home

RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -f -b -p $CONDA_DIR && \
    rm ~/miniconda.sh && \
    ln -s $CONDA_DIR/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda update --all --quiet --yes && \
    conda clean -tipsy && \
    rm -rf ~/.cache/yarn

RUN apt-get update --fix-missing && apt-get -yq dist-upgrade && \
    apt-get install -y \
      curl \
      grep \
      sed \
      dpkg \
    && TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean
# "

RUN wget --quiet https://raw.githubusercontent.com/anosillus/CondaEnvironment/master/environment.yaml -P ~/ && \
    conda env create -f ~/environment.yaml && \
    echo "conda activate python36" >> ~/.bashrc && \
    conda clean --all -f -y && \
    # jupyter labextension install @jupyterlab/hub-extension@^0.12.0 && \
    # npm cache clean --force && \
    rm -rf ~/.cache/yarn && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging

RUN mkdir -p ~/.jupyter && { \
    echo "c.NotebookApp.allow_root = True"; \
    echo "c.NotebookApp.ip = '0.0.0.0'"; \
    echo "c.NotebookApp.token = ''"; \
    echo "c.JupyterLabTemplates.template_dirs = ['list', 'of', 'template', 'directories']"; \
    echo "c.JupyterLabTemplates.include_default = True"; \
    } | tee ~/.jupyter/jupyter_notebook_config.py

RUN mkdir $HOME/notebook && \
    mkdir $HOME/data

VOLUME $HOME/notebook
VOLUME $HOME/data

ENV PATH $CONDA_DIR/envs/python36/bin:$PATH

SHELL ["/bin/bash", "-c"]

RUN wget https://raw.githubusercontent.com/anosillus/CondaEnvironment/master/jupyter_lab_ext.sh -P ~/ && \
    chmod 700 ~/jupyter_lab_ext.sh && \
    ~/jupyter_lab_ext.sh && \
    rm -rf /opt/conda/share/jupyter/lab/staging

RUN apt-get update --fix-missing && \
    apt-get install -y fish texlive-xetex fonts-ipafont fonts-ipaexfont fonts-noto-cjk && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    mkdir -p ~/.config/fish && \
    touch ~/.config/fish/fish.config && \
    echo "source opt/conda/etc/fish/conf.d/conda.fish" >> ~/.config/fish/fish.config && \
    echo "conda activate python36" >> ~/.config/fish/fish.config

EXPOSE 8888
ENTRYPOINT [ "/usr/bin/tini", "--" ]
# CMD ["/bin/bash/", "cd", "$HOME", ";", "jupyter" ,"lab", "--no-browser"]
