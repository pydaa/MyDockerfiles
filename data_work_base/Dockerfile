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
    wget --quiet https://raw.githubusercontent.com/anosillus/CondaEnvironment/master/environment.yaml -P ~/environment.yaml
RUN /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh
RUN ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    # conda-forge maight be better.
RUN /opt/conda/bin/conda config --system --prepend channels conda-forge
RUN conda clean -tipsy
RUN rm -rf /home/.cache/yarn

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

RUN mkdir -p /root/.jupyter \
  && echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py \
  && echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py \
  && echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py

RUN mkdir /home/notebook && \
    mkdir /home/data

VOLUME /home/notebook
VOLUME /home/data


RUN conda env create -f ~/environment.yaml && \
    echo "conda activate python36" >> ~/.bashrc && \
    npm cache clean --force && \

ENV PATH /opt/conda/envs/python36/bin:$PATH

# graphviz
# RUN /bin/bash -c "pip install pygraphviz --install-option='--include-path=/usr/include/graphviz' --install-option='--library-path=/usr/lib/graphviz/'" 
#
SHELL ["/bin/bash", "-c"]
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    jupyter labextension install @jupyterlab/git --no-build && \
    # jupyter labextension install @ryantam626/jupyterlab_black --no-build && \
    # jupyter labextension install jupyterlab-dash@0.1.0-alpha.2 --no-build && \
    # pip install https://github.com/ryantam626/jupyterlab_black/archive/master.zip && \
    jupyter labextension install @jupyterlab/hub-extension --no-build && \
    jupyter labextension install @jupyterlab/latex --no-build && \
    jupyter labextension install @jupyterlab/plotly-extension --no-build && \
    jupyter labextension install @jupyterlab/toc --no-build && \
    jupyter labextension install @jupyterlab/vega3-extension --no-build && \
    jupyter labextension install @lckr/jupyterlab_variableinspector --no-build && \
    jupyter labextension install @ryantam626/jupyterlab_code_formatter --no-build && \
    jupyter labextension install bqplot --no-build && \
    jupyter labextension install jupyter-leaflet --no-build && \
    jupyter labextension install jupyter-matplotlib --no-build && \
    jupyter labextension install jupyterlab-chart-editor --no-build && \
    jupyter labextension install jupyterlab-drawio --no-build && \
    jupyter labextension install jupyterlab-kernelspy --no-build && \
    jupyter labextension install jupyterlab_bokeh --no-build && \
    jupyter labextension install jupyterlab_tensorboard --no-build && \
    jupyter labextension install nbdime-jupyterlab --no-build && \
    jupyter labextension install plotlywidget --no-build && \
    # jupyter serverextension enable --py jupyterlab_black && \
    jupyter serverextension enable --py jupyterlab_git && \
    jupyter serverextension enable --py jupyterlab_code_formatter && \
    jupyter lab build && \
        jupyter lab clean && \
        npm cache clean --force && \
        rm -rf $HOME/.node-gyp && \
        rm -rf $HOME/.local

RUN touch ~/.config/fish/fish.config && \
    echo "source opt/conda/etc/fish/conf.d/conda.fish" >> ~/.config/fish/fish.config && \
    echo "conda activate python36" >> ~/.config/fish/fish.config && \
    apt-get update --fix-missing && \
    apt-get install -y fish && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean

EXPOSE 8888
WORKDIR $HOME

ENTRYPOINT [ "/usr/bin/tini", "--" ]
# CMD ["/bin/bash/", "cd", "$HOME", ";", "jupyter" ,"lab", "--no-browser"]
