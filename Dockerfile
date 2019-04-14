ARG BASE_CONTAINER=debian:stretch-20190326-slim@sha256:bade11bf1835c9f09b011b5b1cf9f7428328416410b238d2f937966ea820be74
FROM $BASE_CONTAINER

LABEL author="tida"
ARG USER_NAME="tida-g"

# ENV LANGUAGE = "en_US:en",
# ENV LC_ALL = "en_US.UTF-8",
# ENV LANG = "en_US.UTF-8"
# ENV PATH=$CONDA_DIR/bin:$PATH
# ENV HOME=/home/$USER_NAME

USER root

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NOWARNINGS yes

ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    bzip2 \
    curl \
    ca-certificates \
    fonts-liberation \
    git \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    locales \
    mercurial \
    subversion \
    sudo \
    wget \
    fish \
    vim \
# This is unti-pattern of node instalation.
 && curl -sL https://deb.nodesource.com/setup_9.x | bash - \
 && apt-get install -q nodejs \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get clean


RUN apt-get update --fix-missing && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    # opencv
      libjpeg-dev \
      libpng-dev \
      libtiff-dev \
      libavcodec-dev \
      libavformat-dev \
      libswscale-dev \
      libv4l-dev \
      libxvidcore-dev \
      libx264-dev \
    # graphviz
      graphviz \
      libgraphviz-dev \
      graphviz-dev \
      pkg-config \
    && rm -rf /var/lib/apt/lists/* \
  && apt-get clean

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc

ENV TINI_VERSION v0.16.1
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini

RUN mkdir -p /root/.jupyter \
  && echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py \
  && echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py \
  && echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py

EXPOSE 8888

RUN mkdir /notebook
VOLUME /notebook

RUN conda update --quiet --yes -n base conda && \
    conda create -n python36 python=3.6 && \
    source activate python36 && \
    # conda update --quiet --yes conda && \
    echo "conda activate base" >> ~/.bashrc && \
    echo "source activate env" >> ~/.bashrc

ENV PATH /opt/conda/envs/env/bin:$PATH

# graphviz
# RUN pip install pygraphviz --install-option="--include-path=/usr/include/graphviz" \
 # --install-option="--library-path=/usr/lib/graphviz/" 

# RUN conda install --quiet --yes -c conda-forge \
RUN conda install --quiet --yes -c\
      bokeh \
      chainer \
      flake8 \
      graphviz \
      'holoviews=1.11.3' \
      ipykernel \
      jupyterlab \
      matplotlib \
      networkx \
      numpy \
      pandas \
      pydotplus\
      scikit-image \
      scikit-learn \
      scipy \
      seaborn \
      statsmodels \
      tqdm \
      typing \
      # mypy \
 && conda install --quiet --yes -c conda-forge \
      # pyviz \
      # xgboost \
      'opencv==4.0.*'

RUN pip install --upgrade pip && \
    pip install -q \
      # dowhy \
      japanize_matplotlib \
      jupyter-tensorboard \
      /* jupyterlab-discovery \ */
      optuna \
      plotly \
      'tensorflow==2.0.0a0'

RUN jupyter labextension install \
      jupyterlab-flake8

# RUN conda install --quiet --yes \
#     'rpy2=2.9*' \
#     r-base \
#     'r-irkernel=0.8*' \
#     'r-plyr=1.8*' \
#     'r-devtools=1.13*' \
#     r-tidyverse \
#     'r-shiny=1.2*' \
#     'r-rmarkdown=1.11*' \
#     'r-forecast=8.2*' \
#     'r-rsqlite=2.1*' \
#     'r-reshape2=1.4*' \
#     'r-nycflights13=1.0*' \
#     'r-caret=6.0*' \
#     'r-rcurl=1.95*' \
#     'r-crayon=1.3*' \
#     'r-htmltools=0.3*' \
#     'r-sparklyr=0.9*' \
#     'r-htmlwidgets=1.2*' \
#     'r-hexbin=1.27*' && \
#     conda clean -tipsy && \
#     fix-permissions $CONDA_DIR && \
#     fix-permissions /home/$NB_USER

ENTRYPOINT [ "/usr/bin/tini", "--" ]
CMD ["nohup jupyter lab --no-browser & fish"]

