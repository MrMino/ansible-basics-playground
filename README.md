# Basic Docker image with sshd and python3 for playing with ansible

Use this image for setting up docker container that ansible can work on.

## Setting things up

The following assumes you are running a distribution of Linux based on Ubuntu.
With a bit of effort this can be adapted to other distros too.
Docker installation step should also work on Debian, for Ansible instalation
you might want to look into [official manuals](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-debian).

Use the commands below to:

* Make sure that you have Docker and Ansible on your host
* Add proper proxy settings to Docker
* Build the image
* Add ssh key to ssh-agent

*If you have Docker and Ansible already installed on your system, and you can
run `sudo docker run hello-world`, skip to "Build the image" step.*

```
cd <path_to_this_repository_dir>

# Install Docker
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce docker-ce-cli containerd.io

# Install Ansible
# Taken from https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-ubuntu
sudo apt update
sudo apt install software-properties-common
sudo apt-add-repository --yes --update ppa:ansible/ansible
sudo apt install ansible
```

```
# Configure proxy settings
# !! Make sure that http-proxy.conf and config.json contain the correct IPs !!
sudo mkdir /etc/systemd/system/docker.service.d/
sudo cp --backup http-proxy.conf /etc/systemd/system/docker.service.d/http-proxy.conf
mkdir ~/.docker
cp config.json ~/.docker/config.json
```

```
# Check your docker installation
sudo docker run hello-world

# Build the provided image
sudo docker build --tag michalik/ansible-node .

# Add ssh key for the container to your ssh agent
ssh-add id_rsa
```

Now, check if everything works as expected:
```
# Run ansible-node container
sudo docker run --net=host -it michalik/ansible-node

# Ping the container
ansible all -m ping -i '127.0.0.1:12345,' -u root
```

## Troubleshooting

If `docker build` or `docker run hello-world` fails with a timeout while
downloading required images, make sure that the proxy settings you used in
`http-proxy.conf` and `.docker/config.json` are the same ones that you use on
your system.

Most probably these settings are already stored in your environment variables:

```
env | grep -i proxy
```

---
Made by Błażej Michalik
