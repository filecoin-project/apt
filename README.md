# apt
A signed Debian APT Software Repository for Filecoin software.

Current packages include curio-cuda and curio-opencl from Curio Storage, Inc.

Users can benefit from this repo on their Ubuntu / Debian system by doing:

```
echo "deb https://filecoin-project.github.io/apt stable main" | sudo tee /etc/apt/sources.list.d/curio-repo.list

wget -O - https://filecoin-project.github.io/apt/KEY.gpg | sudo apt-key add -

sudo apt update

sudo apt install curio-cuda
   or
sudo apt install curio-opencl
```
