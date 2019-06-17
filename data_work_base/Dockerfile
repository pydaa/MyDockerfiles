ARG BASE_CONTAINER=debian@sha256:9490c476443a3869e39c2897fa66c91daf5dcbbfca53c976dac7bbdc45775b28
FROM $BASE_CONTAINER

LABEL author="anosillus"

ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home

USER root

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes

WORKDIR $HOME

RUN apt-get update --fix-missing && apt-get -yq dist-upgrade && \
    apt-get install -y \
      bzip2 \
      ca-certificates \
      git \
      libglib2.0-0\
      libsm6 \
      libxext6 \
      libxrender1 \
      mercurial \
      subversion \
      wget \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

ENV MINICONDA_VERSION=4.5.12 \
    CONDA_VERSION=4.6.7

RUN wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    # conda-forge maight be better.
    /opt/conda/bin/conda config --system --prepend channels conda-forge && \
    conda clean -tipsy && \
    rm -rf /home/.cache/yarn

 RUN set -x && \
    wget --quiet https://raw.githubusercontent.com/anosillus/CondaEnvironment/master/environment.yaml -P ~/ && \
    /opt/conda/bin/conda env create -f ~/environment.yaml && \
    echo "conda activate python36" >> ~/.bashrc && \
    npm cache clean --force

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

RUN mkdir -p ~/.jupyter && \
    {echo "c.NotebookApp.allow_root = True"; \
     echo "c.NotebookApp.ip = '0.0.0.0'"; \
     echo "c.NotebookApp.token = ''"; \
     echo "c.JupyterLabTemplates.template_dirs = ['list', 'of', 'template', 'directories']"; \
     echo "c.JupyterLabTemplates.include_default = True"; \
    } | tee ~/.jupyter/jupyter_notebook_config.py

RUN mkdir /home/notebook && \
    mkdir /home/data

VOLUME /home/notebook
VOLUME /home/data

ENV PATH /opt/conda/envs/python36/bin:$PATH

SHELL ["/bin/bash", "-c"]

RUN set -x && \
    wget https://github.com/anosillus/CondaEnvironment/blob/master/jupyter_lab_ext.sh -P ~/ && \
    ~/jupyter_lab_ext.sh

RUN apt-get update --fix-missing && \
    apt-get install -y fish texlive-xetex && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    touch ~/.config/fish/fish.config && \
    echo "source opt/conda/etc/fish/conf.d/conda.fish" >> ~/.config/fish/fish.config && \
    echo "conda activate python36" >> ~/.config/fish/fish.config && \

EXPOSE 8888
ENTRYPOINT [ "/usr/bin/tini", "--" ]
# CMD ["/bin/bash/", "cd", "$HOME", ";", "jupyter" ,"lab", "--no-browser"]
