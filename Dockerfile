#to build use: sudo docker build -t juio ./
#to run use: sudo docker run -d --memory=500m --cpus="0.3" -p 9999:8888 juio:latest /bin/bash -c "mkdir /opt/notebooks && /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --NotebookApp.token=''  --port=8888 --no-browser --allow-root"
FROM ubuntu:16.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion

RUN wget --quiet https://repo.anaconda.com/archive/Anaconda3-5.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/conda && \
    rm ~/anaconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN apt-get install -y curl grep sed dpkg && \
    TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
    curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python-software-properties
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:jonathonf/gcc-7.2
RUN apt-get update -y
RUN apt-get install -y gcc-7
RUN cd /usr/bin && ln -s gcc-7 gcc
RUN conda install xeus-cling notebook -c QuantStack -c conda-forge -y

RUN conda install -y -c QuantStack -c conda-forge notebook gtest cmake breathe xsimd xtensor xproperty xtensor xleaflet ipyleaflet  xeus-cling xwidgets xplot xtl widgetsnbextension bqplot
RUN conda install -y nodejs
RUN conda install -c hargup/label/pypi mosquitto
