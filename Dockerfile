FROM nvcr.io/nvidia/cuda

ENV TZ=Europe/Madrid
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub 128
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub 
RUN apt-get update

RUN apt-get install -y python3-pip 
RUN pip3 install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu113
RUN pip install \
    tensorflow  \
    jupyter \
    matplotlib \
    h5py \
    scipy \
    pandas \
    scikit-learn \
    seaborn \
    deap \
    imblearn \
    shap

RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    echo "LANG=en_US.UTF-8" > /etc/locale.conf \
    locale-gen en_US.UTF-8

#clean the package cache
RUN rm -rf /var/lib/apt/lists/*

ENV SHELL=/bin/bash

WORKDIR /use_cases

COPY requirements.txt /use_cases/requirements.txt

RUN python3 -m pip install --no-cache-dir -r /use_cases/requirements.txt

CMD ["jupyter-lab", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]