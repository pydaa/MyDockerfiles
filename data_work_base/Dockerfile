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

RUN mkdir -p /tmp && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -P /tmp && \
    wget --quiet https://raw.githubusercontent.com/anosillus/CondaEnvironment/master/environment.yaml -P /tmp && \
    # It maight be not required.
    # chmod +x Miniconda-latest-Linux-x86_64.sh && \
    /bin/bash /tmp/Miniconda-latest-Linux-x86_64.sh -b -p $CONDA_DIR && \
    rm /tmp/Miniconda-latest-Linux-x86_64.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    # conda-forge maight be better.
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda install --quiet --yes && \
    $CONDA_DIR/bin/conda update conda --quiet --yes && \
    conda clean -tipsy && \
    rm -rf /home/.cache/yarn
    # ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    # echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

RUN [ "/bin/bash", "-c", "conda install tini -y"]

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

EXPOSE 8888
WORKDIR $HOME

ENTRYPOINT [ "/usr/bin/tini", "--" ]
# ENTRYPOINT ["tini", "-g", "--"]
# CMD ["/bin/bash/", "cd", "$HOME", ";", "jupyter" ,"lab", "--no-browser"]
