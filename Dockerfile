# Download base image ubuntu 18.04
FROM ubuntu:18.04

# LABEL about the custom image
LABEL maintainer="Kate Markelova"
LABEL maintainer.email="markelova.ke@gmail.com"

# ENV variables
ENV SOFT='/soft'
ENV SAMTOOLS='/soft/samtools-1.15.1'
ENV HTSLIB='/soft/htslib-1.15.1'
ENV LIBDEFLATE='/soft/libdeflate-1.12'
ENV LIBMAUS2='/soft/libmaus2-2.0.810-release-20220216151520'
ENV BIOBAMBAM2='/soft/biobambam2-2.0.180-release-20210315231707'


# Disable Prompt During Packages Installation
ARG DEBIAN_FRONTEND=noninteractive

# install dependencies, cleanup apt garbage
RUN apt-get update && apt-get install -y python3-pip

RUN apt-get update && apt-get install --no-install-recommends -y \
    libncurses5-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-gnutls-dev \
    zlibc \
    zlib1g \
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
    automake \
    apt-utils \
    pkg-config \
    libtool && \
    apt-get clean && apt-get purge && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

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

# biobambam2 needs libmaus2
# libmaus2-2.0.810 released this on 16 Feb 2022
RUN wget https://gitlab.com/german.tischler/libmaus2/-/archive/2.0.810-release-20220216151520/libmaus2-2.0.810-release-20220216151520.tar.gz && \
    tar xvzf libmaus2-2.0.810-release-20220216151520.tar.gz && \
    rm libmaus2-2.0.810-release-20220216151520.tar.gz && \
    cd libmaus2-2.0.810-release-20220216151520 && \
    ./configure --prefix=$LIBMAUS2 && \
    make && \
    make install

# biobambam2-2.0.180 released this on 18 Mar 2021
RUN wget https://gitlab.com/german.tischler/biobambam2/-/archive/2.0.180-release-20210315231707/biobambam2-2.0.180-release-20210315231707.tar.gz && \
    tar xvzf biobambam2-2.0.180-release-20210315231707.tar.gz && \
    rm biobambam2-2.0.180-release-20210315231707.tar.gz && \
    cd biobambam2-2.0.180-release-20210315231707/ && \
    autoreconf -i -f && \
    ./configure --with-libmaus2=$LIBMAUS2 \
	--prefix=$BIOBAMBAM2 && \
    make install

ENV PATH=${PATH}:$HTSLIB:$SAMTOOLS:$LIBDEFLATE:$LIBMAUS2:$BIOBAMBAM2:$SOFT

CMD ["bash"]