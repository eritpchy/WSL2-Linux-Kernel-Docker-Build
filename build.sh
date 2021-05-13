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

IMAGE=wsl2-linux-kernel-docker-build

docker build . -t $IMAGE

echo "Finish, press 'Enter' key to exit"
read