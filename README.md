## Docker container with eisfair-ng SDK
 
 This is a docker implementation of eisfair-ng buildnode for Jenkins.

 For more information please refer to [Official website](https://web.nettworks.org/wiki/display/eng/eisfair-ng+Wiki) or [Support forum](https://web.nettworks.org/forum/)

### 1. Install docker

 This instruction works for a <b>Centos7</b> docker host. Other distributions may need some adjustments.

```shell
sudo tee /etc/yum.repos.d/docker.repo <<-'EOF'
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7/
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
...
sudo yum install docker-engine -y
...
sudo systemctl enable docker.service
...
sudo systemctl start docker.service
```

### 2. Build/Use the Container

You now have two options: 
- Build from scratch or 
- Pull the ready-made image from DockerHub. 

#### 2a Image from Docker Hub

```shell
sudo docker pull starwarsfan/eisfair-ng-buildnode
```

#### 2b Build from scratch

##### Pull repo from github

```shell
sudo git clone https://github.com/starwarsfan/eisfair-ng-buildnode.git
cd eisfair-ng-buildnode
```

##### Build image

```shell
sudo docker build -t starwarsfan/eisfair-ng-buildnode:latest .
```

### 3. Starting docker container

```shell
sudo docker run --name eisfair-ng-buildnode -d starwarsfan/eisfair-ng-buildnode:latest
```

#### 3.a Mount volume or folder for svn checkout

With the additional run parameter _-v <host-folder>:/opt/git-clone/_ you can mount a folder on the docker 
host which contains the the git clone outside of the container. So the run command may look like the following example:

```shell
sudo docker run --name eisfair-ng-buildnode -v /data/git-clone/:/opt/git-clone/ ...
```

### 5. Useful commands

Check running / stopped container:

```shell
sudo docker ps -a
```

Stop the container

```shell
sudo docker stop eisfair-ng-buildnode
```

Start the container

```shell
sudo docker start eisfair-ng-buildnode
```

Get logs from container

```shell
sudo docker logs -f eisfair-ng-buildnode
```

Open cmdline inside of container

```shell
sudo docker exec -i -t eisfair-ng-buildnode /bin/bash
```
