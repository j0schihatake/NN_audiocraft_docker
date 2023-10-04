ARG TAG=latest
FROM continuumio/miniconda3:$TAG

RUN apt-get update \
    && DEBIAN_FRONTEND="noninteractive" apt-get install -y --no-install-recommends \
        git \
        locales \
        sudo \
        build-essential \
        dpkg-dev \
        wget \
        openssh-server \
        ca-certificates \
        netbase\
        tzdata \
        nano \
        software-properties-common \
        python3.9-venv \
        python3.9-tk \
        pip \
        bash \
        git \
        ncdu \
        net-tools \
        openssh-server \
        libglib2.0-0 \
        libsm6 \
        libgl1 \
        libxrender1 \
        libxext6 \
        ffmpeg \
        wget \
        curl \
        psmisc \
        rsync \
        vim \
        unzip \
        htop \
        pkg-config \
        libcairo2-dev \
        libgoogle-perftools4 libtcmalloc-minimal4  \
    && rm -rf /var/lib/apt/lists/*

# Setting up locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# RUN service ssh start
EXPOSE 7865

# Create user:
RUN groupadd --gid 1020 audiocraft-group
RUN useradd -rm -d /home/audiocraft-user -s /bin/bash -G users,sudo,audiocraft-group -u 1000 audiocraft-user

RUN python3 -m pip install torch torchvision torchaudio

# Update user password:
RUN echo 'audiocraft-user:admin' | chpasswd

RUN mkdir /home/audiocraft-user/audiocraft

RUN git clone https://github.com/facebookresearch/audiocraft.git /home/audiocraft-user/audiocraft

#ADD ./requirements.txt /home/audiocraft-user/audiocraft/

#RUN cd /home/audiocraft-user/audiocraft/ && \
#    python3 -m pip install -r requirements.txt

RUN pip install 'torch>=2.0'

RUN pip install -U audiocraft

#RUN pip install -U git+https://git@github.com/facebookresearch/audiocraft#egg=audiocraft

# Preparing for login
ENV HOME /home/audiocraft-user/audiocraft/

RUN mv ${HOME}/demos/musicgen_app.py ${HOME}/app.py

WORKDIR ${HOME}

CMD python3 app.py --listen 0.0.0.0
# python -m musicgen_app.py --share

# Docker:
# docker build -t audiocraft .
# docker run -dit --name audiocraft -p 7860:7860 --gpus all --restart unless-stopped audiocraft:latest
