# apt
An official, signed Debian APT Software Repository for FileCoin software.

This is following the guide materials from: https://assafmo.github.io/2019/05/02/ppa-repo-hosted-on-github.html

Once this repo is working, setup for users should be:
```
curl -s --compressed "https://filecoin-project.github.io/apt/KEY.gpg" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/filecoin.gpg >/dev/null
sudo curl -s --compressed -o /etc/apt/sources.list.d/my_list_file.list "https://filecoin-project.github.io/apt/my_list_file.list"
sudo apt update
```
