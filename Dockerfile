
MINICONDA_VERSION=4.5.12 \
CONDA_VERSION=4.6.7
CONDA_DIR=/opt/conda \

apt-get update --fix-missing && apt-get -yq dist-upgrade \
 && sudo apt-get install -yq --no-install-recommends \
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
    wget 


wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    . /tmp/miniconda.sh -b -p $CONDA_DIR && \
    rm /tmp/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda install --quiet --yes conda="${CONDA_VERSION%.*}.*" && \
    $CONDA_DIR/bin/conda update conda --quiet --yes && \
    conda clean -tipsy && \
    rm -rf /home/.cache/yarn


mkdir -p /root/.jupyter \
  && echo "c.NotebookApp.allow_root = True" >> /root/.jupyter/jupyter_notebook_config.py \
  && echo "c.NotebookApp.ip = '0.0.0.0'" >> /root/.jupyter/jupyter_notebook_config.py \
  && echo "c.NotebookApp.token = ''" >> /root/.jupyter/jupyter_notebook_config.py

mkdir /home/notebook && \
mkdir /home/data

bash

conda env create -f /tmp/environment.yaml && \
echo "source activate python36 " >> ~/.bashrc && \
sudo npm cache clean --force


jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
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

