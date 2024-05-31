#!/bin/bash

echo "Copy new DEB files to pool/main/\$ARCH, then run this script"
echo "This also requires the private key for support@curiostorage.org in your keyring"

REPO_PATH=$(dirname "$(realpath "$0")")
ARCHITECTURES=("amd64" "arm64")

cd "$REPO_PATH" || exit

# Create Packages.gz for each architecture
for ARCH in "${ARCHITECTURES[@]}"; do
  dpkg-scanpackages --multiversion "pool/main/$ARCH" /dev/null | gzip -9c > "dists/stable/main/binary-$ARCH/Packages.gz"
  echo "Created Packages.gz for $ARCH"
done

# Create Sources.gz if source packages exist
SOURCE_DIR="pool/main/source"
if find "$SOURCE_DIR" -name "*.dsc" | grep -q .; then
  mkdir -p "dists/stable/main/source"
  dpkg-scansources "$SOURCE_DIR" /dev/null | gzip -9c > "dists/stable/main/source/Sources.gz"
  echo "Created Sources.gz"
fi

# Create the Release file
RELEASE_FILE="dists/stable/Release"
DATE=$(date -Ru)
cat > "$RELEASE_FILE" <<EOF
Archive: stable
Component: main
Origin: CurioStorage
Label: CurioStorage
Suite: stable
Codename: stable
Date: $DATE
Architectures: $(IFS=, ; echo "${ARCHITECTURES[*]}")
EOF

# Add MD5 and SHA256 checksums to the Release file
{
  echo "MD5Sum:"
  find dists/stable -type f ! -name "Release" -exec md5sum {} \; | awk '{ print " " $1 " " $2 }'
  
  echo "SHA256:"
  find dists/stable -type f ! -name "Release" -exec sha256sum {} \; | awk '{ print " " $1 " " $2 }'
} >> "$RELEASE_FILE"

# Sign the Release file (ASCII armored) and always overwrite
gpg --default-key "support@curiostorage.org" --armor --detach-sign --yes --batch -o "dists/stable/Release.gpg" "$RELEASE_FILE"
gpg --default-key "support@curiostorage.org" --clearsign --yes --batch -o "dists/stable/InRelease" "$RELEASE_FILE"

echo "Repository updated and indexed successfully."
