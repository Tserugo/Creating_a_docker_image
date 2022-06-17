# Download base image ubuntu 18.04
FROM ubuntu:18.04

ENV SOFT='/soft'
ENV SAMTOOLS='/soft/samtools-${SAMTOOLSVER}'
ENV HTSLIB='/soft/htslib-${HTSLIBVER}'
ENV LIBDEFLATE='/soft/libdeflate-${LIBDEFLATEVER}'

# LABEL about the custom image
LABEL maintainer="Kate Markelova"
LABEL maintainer.email="markelova.ke@gmail.com"

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

WORKDIR $SOFT

# samtools-1.15.1 released on 7 Apr 2022
RUN wget https://github.com/samtools/samtools/releases/download/1.15.1/samtools-1.15.1.tar.bz2 && \
    tar jxf samtools-1.15.1.tar.bz2 && \
    rm samtools-1.15.1.tar.bz2 && \
    cd samtools-1.15.1 && \
    autoheader && \
    autoconf -Wno-syntax && \
    ./configure --prefix $SAMTOOLS && \
    make && \
    make install

# htslib-1.15.1 released on 7 Apr 2022
RUN wget https://github.com/samtools/htslib/releases/download/1.15.1/htslib-1.15.1.tar.bz2 && \
    tar jxf htslib-1.15.1.tar.bz2 && \
    rm htslib-1.15.1.tar.bz2 && \
    cd htslib-1.15.1 && \
    autoreconf -i && \
    ./configure --prefix $HTSLIB && \
    make && \
    make install

# libdeflate-1.12 released on 13 Jun 2022
RUN wget https://github.com/ebiggers/libdeflate/archive/refs/tags/v1.12.tar.gz && \
    tar  -xvzf v1.12.tar.gz && \
    rm v1.12.tar.gz && \
    cd libdeflate-1.12 && \
    make && \
    make DESTDIR=$LIBDEFLATE install

CMD ["bash"]