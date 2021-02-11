#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

echo
echo "Building chaos-kraken Docker image in GKE.."
echo

docker-compose build

echo 
echo "Deploy chaos-kraken Helm chart..."
echo
helm install chaos-kraken chaos-kraken/helm
