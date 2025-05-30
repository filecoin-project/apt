#!/bin/bash

echo "Copy new DEB files to pool/main/\$ARCH, then run this script"
echo "This also requires the private key for support@curiostorage.org in your keyring"

ARCHITECTURES=("amd64" "arm64")

# Create Packages, Packages.gz, and Packages.xz for each architecture
for ARCH in "${ARCHITECTURES[@]}"; do
  mkdir -p "dists/stable/main/binary-$ARCH"
  dpkg-scanpackages "pool/main/$ARCH" /dev/null | tee "dists/stable/main/binary-$ARCH/Packages" | gzip -9c > "dists/stable/main/binary-$ARCH/Packages.gz"
  dpkg-scanpackages "pool/main/$ARCH" /dev/null | xz -9c > "dists/stable/main/binary-$ARCH/Packages.xz"
  echo "Created Packages, Packages.gz, and Packages.xz for $ARCH"
done

# Create Sources.gz and Sources.xz if source packages exist
SOURCE_DIR="pool/main/source"
if find "$SOURCE_DIR" -name "*.dsc" | grep -q .; then
  mkdir -p "dists/stable/main/source"
  dpkg-scansources "$SOURCE_DIR" /dev/null | tee "dists/stable/main/source/Sources" | gzip -9c > "dists/stable/main/source/Sources.gz"
  dpkg-scansources "$SOURCE_DIR" /dev/null | xz -9c > "dists/stable/main/source/Sources.xz"
  echo "Created Sources, Sources.gz, and Sources.xz"
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
Architectures: ${ARCHITECTURES[*]}
EOF

# Add checksums to the Release file
{
  echo "MD5Sum:"
  find dists/stable -type f ! -name "Release" ! -name "Release.gpg" ! -name "InRelease" -exec md5sum {} \; | sed -e 's@dists/stable/@@' | while read -r checksum path; do
    size=$(stat --format=%s "dists/stable/$path")
    printf " %s %d %s\n" "$checksum" "$size" "$path"
  done
  
  echo "SHA256:"
  find dists/stable -type f ! -name "Release" ! -name "Release.gpg" ! -name "InRelease" -exec sha256sum {} \; | sed -e 's@dists/stable/@@' | while read -r checksum path; do
    size=$(stat --format=%s "dists/stable/$path")
    printf " %s %d %s\n" "$checksum" "$size" "$path"
  done
} >> "$RELEASE_FILE"

# Sign the Release file (ASCII armored) and always overwrite
gpg --default-key "support@curiostorage.org" --armor --detach-sign --yes --batch -o "dists/stable/Release.gpg" "$RELEASE_FILE"
gpg --default-key "support@curiostorage.org" --clearsign --yes --batch -o "dists/stable/InRelease" "$RELEASE_FILE"

echo "Repository updated and indexed successfully."
