# MyDockerfiles

docker build ./ -t dataEnv

docker run --rm -it -p 8888:8888 -v dataEnv

jupyter lab --notebook-dir=/notebooks
