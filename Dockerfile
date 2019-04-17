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
    # curl \
    # fonts-liberation \
    # gcc \
    # gnupg2 \
    # locales \
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

# RUN apt-get update && apt-get install -y --no-install-recommends gnupg2 curl ca-certificates && \
#     curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub | apt-key add - && \
# #     echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list && \
# #     echo "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/nvidia-ml.list && \
# #     apt-get purge --autoremove -y curl && \
# #     rm -rf /var/lib/apt/lists/*
# #
# # ENV CUDA_VERSION 10.1.105
# # ENV CUDA_PKG_VERSION 10-1=$CUDA_VERSION-1
# # ENV CUDNN_VERSION 7.5.0.56
# # LABEL com.nvidia.cudnn.version="${CUDNN_VERSION}"
# #
#
# # For libraries in the cuda-compat-* package: https://docs.nvidia.com/cuda/eula/index.html#attachment-a
# RUN apt-get update && apt-get install -y --no-install-recommends \
#         cuda-cudart-$CUDA_PKG_VERSION \
#         cuda-compat-10-1 \
#         libcudnn7=$CUDNN_VERSION-1+cuda10.1 \
#         libcudnn7-dev=$CUDNN_VERSION-1+cuda10.1 && \
#     apt-mark hold libcudnn7 && \
#     ln -s cuda-10.1 /usr/local/cuda && \
#     rm -rf /var/lib/apt/lists/*
#
# # Required for nvidia-docker v1
# RUN echo "/usr/local/nvidia/lib" >> /etc/ld.so.conf.d/nvidia.conf && \
#     echo "/usr/local/nvidia/lib64" >> /etc/ld.so.conf.d/nvidia.conf && \
#     echo -e "\n## CUDA and cuDNN paths" >> ~/.bashrc && \
#     echo 'export PATH=/usr/local/cuda-10.1/bin:/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}' >> ~/.bashrc && \
#     echo 'export LD_LIBRARY_PATH=/usr/local/nvidia/lib:/usr/local/nvidia/lib64:${LD_LIBRARY_PATH}' >> ~/.bashrc

# ENV PATH /usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}
# ENV LD_LIBRARY_PATH /usr/local/nvidia/lib:/usr/local/nvidia/lib64

# RUN curl -sL https://deb.nodesource.com/setup_9.x | bash - \
# # echo 'deb https://deb.nodesource.com/node_9.x stretch main' > /etc/apt/sources.list.d/nodesource.list \
# # && curl -sL https://deb.nodesource.com/setup_9.x | bash - \
# RUN apt-get update -qq \
#  && apt-get install -yq --no-install-recommends \
#  && apt-get install -yq nodejs \
#  && rm -rf /var/lib/apt/lists/* \
#  && apt-get clean
#
# RUN apt-get update -qq \
# && apt-get install -yq --no-install-recommends \
#    # opencv
#      libjpeg-dev \
#      libpng-dev \
#      libtiff-dev \
#      libavcodec-dev \
#      libavformat-dev \
#      libswscale-dev \
#      libv4l-dev \
#      libxvidcore-dev \
#      libx264-dev \
#    # graphviz
#      graphviz \
#      libgraphviz-dev \
#      graphviz-dev \
#      pkg-config \
#    && rm -rf /var/lib/apt/lists/* \
#  && apt-get clean

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

# RUN conda install --quiet --yes 'tini=0.18.0' && \
    # conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
    # conda clean -tipsy

# ENV TINI_VERSION v0.16.1
# ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
# RUN chmod +x /usr/bin/tini

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
    # conda update --quiet --yes -n python36 conda && \
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
        rm -rf $HOME/.local && \

EXPOSE 8888
WORKDIR $HOME

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD ["/bin/bash/", "cd", "$HOME", ";", "jupyter" ,"lab", "--no-browser"]
