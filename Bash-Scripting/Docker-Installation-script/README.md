# Docker Installation Script

## Description,
   This script will install official **docker engine** and **docker compose** individually for ubuntu, cent os, debian, and centos distribution

## Flow Chart

<P align="center">
<img src="./assets/docker installation script.svg" alt="script Flow chart" width="300">
</p>
<!-- ![FlowChart](assets/docker%20installation%20script.svg) -->


## Execution 

- get the specfic file in to your working machine by running,
```
curl -O https://raw.githubusercontent.com/luchichang/Python-and-Bash-Scripting/refs/heads/main/Bash-Scripting/Docker-Installation-script/docker-installer.sh
```

![script-download](./assets/image.png)

- check the file permission and ensure it has execution permission either for user or groups or others. by running,
```
ls -l docker-installer.sh
```

<p align="center">
<img src="./assets/image-1.png" alt="File Permission w/o x" width="80%">
</p>
<!-- ![file permission](./assets/image-1.png) -->

- do this only if ***your file doesn't have execute perm***, 
```
chmod u+x docker-installer.sh && echo "x perm Added :)!" || echo "Failed Adding x perm :("
```

![File perm w x](./assets/image-2.png)

- run the script using `bash docker-installer.sh`

- Hurrah :tada: now official docker package is installed in the desired system. you can check everything works fine by running 
```
sudo docker run hello-world
```

![docker-install-verification](./assets/image-4.png)

### note,

script supports option if you intended to run the script manually then no option is needed.

![user-interaction](./assets/interactive-prompt.png)

whereas, for ***non-interactive*** purpose you can run the script in following way 
```
bash docker-installer.sh --non-interactive
```

<p align="center">
<img src="./assets/ni-suc.png" alt="Running script in non interactive way!" width="90%" >
</p>


## Troubleshoot


![err-unsuported-OS-dist](./assets/Err-unsup-osdist.png)