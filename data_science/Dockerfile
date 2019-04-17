ARG BASE_CONTAINER=debian:stretch-20190326-slim@sha256:bade11bf1835c9f09b011b5b1cf9f7428328416410b238d2f937966ea820be74
FROM $BASE_CONTAINER

LABEL author="tida"

ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash
ENV PATH=$CONDA_DIR/bin:$PATH \
    HOME=/home

COPY environment.yaml /tmp/environment.yaml
USER root

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes

RUN apt-get update --fix-missing && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    bzip2 \
    ca-certificates \
    curl \
    dpkg \
    git \
    grep \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    mercurial \
    sed \
    subversion \
    sudo \
    wget \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean

ENV MINICONDA_VERSION=4.5.12 \
    CONDA_VERSION=4.6.7

# RUN bash -c "curl https://conda.ml | bash"
RUN cd /tmp && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    # $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    # $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda install --quiet --yes conda="${CONDA_VERSION%.*}.*" && \
    $CONDA_DIR/bin/conda update conda --quiet --yes && \
    conda clean -tipsy && \
    rm -rf /home/.cache/yarn
    # ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    # echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

RUN TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
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

ENV PATH /opt/conda/envs/python36/bin:$PATH

RUN conda env create -f /tmp/environment.yaml && \
    echo "source activate python36 " >> ~/.bashrc && \
    npm cache clean --force

# SHELL ["/bin/bash", "-c"]
# graphviz
# RUN /bin/bash -c "pip install pygraphviz --install-option='--include-path=/usr/include/graphviz' --install-option='--library-path=/usr/lib/graphviz/'" 

RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    jupyter labextension install @jupyterlab/git --no-build && \
    jupyter labextension install @jupyterlab/hub-extension --no-build && \
    jupyter labextension install @jupyterlab/latex --no-build && \
    jupyter labextension install @jupyterlab/plotly-extension --no-build && \
    jupyter labextension install @jupyterlab/toc --no-build && \
    jupyter labextension install @jupyterlab/vega3-extension --no-build && \
    jupyter labextension install @lckr/jupyterlab_variableinspector --no-build && \
    jupyter labextension install @ryantam626/jupyterlab_black --no-build && \
    pip install https://github.com/ryantam626/jupyterlab_black/archive/master.zip && \
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
    jupyter serverextension enable --py jupyterlab_black && \
    jupyter serverextension enable --py jupyterlab_git && \
    jupyter lab build && \
        jupyter lab clean && \
        jlpm cache clean && \
        npm cache clean --force && \
        rm -rf $HOME/.node-gyp && \
        rm -rf $HOME/.local

EXPOSE 8888
WORKDIR $HOME

ENTRYPOINT [ "/usr/bin/tini", "--" ]
# CMD ["/bin/bash/", "cd", "$HOME", ";", "jupyter" ,"lab", "--no-browser"]
