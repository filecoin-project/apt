# apt
An official, signed Debian APT Software Repository for Filecoin software.

This is following the guide materials from: https://assafmo.github.io/2019/05/02/ppa-repo-hosted-on-github.html

Once this repo is working, setup for users should be:

```
echo "deb http://filecoin-project.github.com/apt stable main" | sudo tee /etc/apt/sources.list.d/curio-repo.list

wget -O - http://filecoin-project.github.com/apt/KEY.gpg | sudo apt-key add -

sudo apt update

sudo apt install curio-cuda
   or
sudo apt install curio-opencl
```