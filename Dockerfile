# Download base image ubuntu 18.04
FROM ubuntu:18.04

# for easy upgrade later. ARG variables only persist during image build
ARG = "/soft"
ARG SAMTOOLSVER="1.15.1"
ARG HTSLIBVER="1.15"

# LABEL about the custom image
LABEL maintainer="Kate Markelova"
LABEL maintainer.email="markelova.ke@gmail.com"
LABEL version="0.1"

# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies, cleanup apt garbage
RUN apt-get update && apt-get install -y python3-pip

RUN apt-get update && apt-get install --no-install-recommends -y \
 libncurses5-dev \
 libbz2-dev \
 liblzma-dev \
 libcurl4-gnutls-dev \
 zlib1g-dev \
 libssl-dev \
 gcc \
 wget \
 make \
 perl \
 bzip2 \
 gnuplot \
 ca-certificates \
 gawk \
 python3 \
 autoconf \
 automake && \
 rm -rf /var/lib/apt/lists/* && apt-get autoclean

# get samtools
RUN wget https://github.com/samtools/samtools/releases/download/${SAMTOOLSVER}/samtools-${SAMTOOLSVER}.tar.bz2 && \
 tar -xjf samtools-${SAMTOOLSVER}.tar.bz2 && \
 rm samtools-${SAMTOOLSVER}.tar.bz2 && \
 cd samtools-${SAMTOOLSVER} && \
 ./configure && \
 make && \
 make install && \

# get htslib
RUN wget https://github.com/samtools/htslib/releases/download/${HTSLIBVER}/htslib-${HTSLIBVER}.tar.bz2 && \
 tar -vxjf htslib-${HTSLIBVER}.tar.bz2 && \
 rm htslib-${HTSLIBVER}.tar.bz2 && \
 cd htslib-${HTSLIBVER} && \
 make && \
 make install && \

CMD ["bash"]