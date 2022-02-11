FROM ubuntu:20.04
RUN apt update \
	&& apt install -y software-properties-common \
	&& add-apt-repository -y ppa:ubuntu-toolchain-r/test \
	&& apt update \
	&& apt install -y gcc-10 make flex bison libssl-dev libelf-dev git bc libncurses-dev \
	&& ln -s /usr/bin/gcc-10 /usr/bin/gcc \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

RUN cd /root \
	&& git clone --depth=1 -b linux-msft-wsl-5.10.y --single-branch https://github.com/microsoft/WSL2-Linux-Kernel.git

WORKDIR /root/WSL2-Linux-Kernel