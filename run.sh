#!/bin/bash
set -e
err() {
    echo "Error occurred:"
    awk 'NR>L-4 && NR<L+4 { printf "%-5d%3s%s\n",NR,(NR==L?">>>":""),$0 }' L=$1 $0
	echo "Press Enter to continue"
	read
	exit 1
}
trap 'err $LINENO' ERR
cd ${0%/*}
docker rm -f wsl2-linux-kernel-docker-build || true
zcat /proc/config.gz > .config

cat <<EOT >> .config
CONFIG_BLK_DEV_NBD=y
CONFIG_CC_CAN_LINK=y
CONFIG_CC_CAN_LINK_STATIC=y
CONFIG_DMA_SHARED_BUFFER=y
CONFIG_SYNC_FILE=y
CONFIG_STAGING=y
CONFIG_ASHMEM=y
CONFIG_ANDROID=y
CONFIG_ANDROID_BINDER_IPC=y
CONFIG_ANDROID_BINDERFS=y
CONFIG_ANDROID_BINDER_DEVICES="binder,hwbinder,vndbinder"
CONFIG_IPV6_ROUTER_PREF=y
CONFIG_IPV6_ROUTE_INFO=y
CONFIG_IPV6_MULTIPLE_TABLES=y
CONFIG_IPV6_SUBTREES=y
EOT
rm -f vmlinux || true

docker run -it --rm --name wsl2-linux-kernel-docker-build \
	-v $(pwd):/tmp/build \
	-v $(pwd)/.config:/root/WSL2-Linux-Kernel/Microsoft/config \
	wsl2-linux-kernel-docker-build bash -c " \
		cp Microsoft/config Microsoft/config.1 \
        && echo make menuconfig KCONFIG_CONFIG=Microsoft/config.1 \
		&& make -j$(nproc) KCONFIG_CONFIG=Microsoft/config.1 \
		&& cp -f vmlinux /tmp/build/vmlinux \
	"
echo "Finish, press 'Enter' key to exit"
read