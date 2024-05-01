#!/bin/bash

echo "Copy new DEB files to root of this folder, then run this script"
echo "This also requires the private key for support@curiostorage.org in your keyring"

dpkg-scanpackages --multiversion . > Packages
gzip -k -f Packages
apt-ftparchive release . > Release
gpg --default-key "support@curiostorage.org" -abs -o - Release > Release.gpg
gpg --default-key "support@curiostorage.org" --clearsign -o - Release > InRelease

echo "Now commit all and push to the branch: 'main'."
