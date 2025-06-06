#!/bin/sh

declare -a ubUnoffPackages=(
    [0]=docker.io
    [1]=docker-compose
    [2]=docker-compose-v2
    [3]=docker-doc
    [4]=podman-docker
)
# 0: false, 1: true
isInteractive=1

#displays once successfully docker software is installed
sucMsg="docker installed successfully! \n\n run $ sudo docker run hello-world to verify Installation.\n \n Happy Learning :)" 

declare -a rhUnoffPackages=(
    [0]=docker
    [1]=docker-client
    [2]=docker-client-latest
    [3]=docker-common
    [4]=docker-logrotate
    [5]=docker-latest-logrotate
    [7]=podman
    [6]=docker-latest
    [8]=runc
    [9]=docker-engine
)

declare -a suUnoffpackages=(
    [0]=docker
    [1]=docker-client
    [2]=docker-client-latest
    [3]=docker-common
    [4]=runc
    [5]=docker-logrotate
    [6]=docker-latest-logrotate
    [7]=docker-engine
)

getDistribution () {
    echo $(grep ^NAME /etc/os-release | cut -d "=" -f 2 | tr -d '"')
}

rmUnoffPackage () {
    if [ "$1" = "ub" ]; then
        for pkg in ${ubUnoffPackages[@]}; do
          sudo apt-get remove $pkg
        done;
    elif [ "$1" = "rh" ]; then
        for pkg in ${rhUnoffPackages[@]}; do  
          sudo yum remove $pkg
        done;
    elif [ "$1" = "su" ]; then
        for pkg in ${suUnoffpackages[@]}; do
          sudo zypper remove $pkg 
        done;
    else 
        echo "ERR: Unable to remove the package"
    fi;
}

ubuntuDistribution () {
    echo "WARN: Removing un official package"
    rmUnoffPackage ub
    echo "INFO: Adding the repository"
    # Add Docker's official GPG key:
    sudo apt-get update
    sudo apt-get install ca-certificates curl
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add the repository to Apt sources:
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
       $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
       sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    echo "INFO: Installing docker engine."

    sudo apt update -y

    sudo apt-get install $(if [ $isInteractive -eq 0 ]; then echo "-y"; fi) docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin && echo -e $sucMsg 
    
}

redhatDistribution () {
    echo "INFO: Removing un official package"
    rmUnoffPackage rh
    echo "Adding Repo"
    sudo dnf install -y dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo
    sudo dnf update -y
    sudo dnf install $(if [ $isInteractive -eq 0 ]; then echo "-y"; fi) docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable --now docker && echo -e $sucMsg
}

suseDistribution() {
    echo "WARN: Removing un official package"
    rmUnoffPackage su
    echo "INFO: adding the repository"
    opensuseRepo="https://download.opensuse.org/repositories/security:/SELinux/openSUSE_Factory/security:SELinux.repo"
    sudo sed -i 's/$releasever/9/g' /etc/yum.repos.d/docker-ce.repo
    sudo zypper addrepo $opensuseRepo && echo "INFO: repo added successfully"
    sudo zypper install $(if [ $isInteractive -eq 0 ]; then echo "-y"; fi) docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable --now docker && echo -e $sucMsg
}

main () {
    distribution=$(getDistribution)
    # if [$distribution -eq "Red Hat Enterprise Linux"]; then
    case $distribution in
       "Ubuntu")
          ubuntuDistribution
          ;;
        "Red Hat Enterprise Linux")
          redhatDistribution
          ;;
        "Suse")
           suseDistribution
          ;;
        *)
          echo "ERR: script doesn't support $distribution distribution"
          ;;
    esac
}

if [[ $# -eq 1 && "$1" = "--non-interactive" ]]; then
    isInteractive=0
fi;
    
main

