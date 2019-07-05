#!/bin/bash

tag=$1

if [ -z $tag ]; then
  echo "please provide a tag arg"
  exit 1
fi

major=$(echo $tag | awk -F. '{print $1}')
minor=$(echo $tag | awk -F. '{print $2}')
# patch=$(echo $tag | awk -F. '{print $3}')

tf_ver=$(grep TERRAFORM_VERSION Dockerfile | head -n 1 | awk '{print $3}')

echo "Confirm building images for:"
echo "  MAJOR: ${major}"
echo "  MINOR: ${minor}"
echo "  TF_VERSION: ${tf_ver}"

read -p "Proceed? [Y/N] " ans

if [[ "$ans" != "Y" && "$ans" != "y" ]]; then
  echo "Cancelling"
  exit 0
fi

docker build --rm -t lenn4rd/drone-terraform .

set -x
docker tag lenn4rd/drone-terraform:latest lenn4rd/drone-terraform:${tf_ver}

docker push lenn4rd/drone-terraform:latest
docker push lenn4rd/drone-terraform:${tf_ver}
set +x
