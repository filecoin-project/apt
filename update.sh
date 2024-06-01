#!/bin/bash

echo "Copy new DEB files to pool/main/\$ARCH, then run this script"
echo "This also requires the private key for support@curiostorage.org in your keyring"

ARCHITECTURES=("amd64" "arm64")
OVERRIDE_FILE="override"

# Create Packages.gz for each architecture
for ARCH in "${ARCHITECTURES[@]}"; do
  mkdir -p "dists/stable/main/binary-$ARCH"
  dpkg-scanpackages --multiversion "pool/main/$ARCH" /dev/null | tee dists/stable/main/binary-$ARCH/Packages | gzip -9c > "dists/stable/main/binary-$ARCH/Packages.gz"
  
  RELEASE_FILE="dists/stable/main/binary-$ARCH/Release"

  cat <<EOF > RELEASE_FILE
Archive: stable
Component: main
Origin: CurioStorage
Label: CurioStorage
Architecture: $ARCH
EOF
  gpg --default-key "support@curiostorage.org" --armor --detach-sign --yes --batch -o "dists/stable/main/binary-$ARCH/Release.gpg" "$RELEASE_FILE"

  echo "Created Packages, Packages.gz, and Release for $ARCH"
done

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
