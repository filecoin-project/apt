# apt
A signed Debian APT Software Repository for Filecoin software.

Current packages include curio-cuda and curio-opencl from Curio Storage, Inc.

Users can benefit from this repo on their Ubuntu / Debian system by doing:

```
sudo wget -O /usr/share/keyrings/curiostorage-archive-keyring.gpg https://filecoin-project.github.io/apt/KEY.gpg

echo "deb [signed-by=/usr/share/keyrings/curiostorage-archive-keyring.gpg] https://filecoin-project.github.io/apt stable main" | sudo tee /etc/apt/sources.list.d/curiostorage.list

sudo apt update

sudo apt install curio-cuda
   or
sudo apt install curio-opencl
```


For release:
In Curio root:  go run apt/make_debs.go private_key.b64
Copy here to pool/....
here: ./update.sh
commit to main