#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

echo
echo "Creating gcp Kubernetes cluster on GKE (Google Kubernetes Engine)..."
echo
gcloud config set compute/zone $ZONE
gcloud config set project $PROJECT_ID
gcloud container clusters create monitor-jvm --num-nodes=3 


echo
echo "Pre-cache some of the Docker images we'll need..."
echo
docker pull gradle:jdk11
docker pull adoptopenjdk/openjdk11

echo
echo "Deploying the prometheus operator Helm chart..."
echo
helm install --name prometheus --namespace monitoring stable/prometheus-operator --wait

echo
echo "Hit any key to deploy the Chaos Kraken..."
read 
./deploy-chaos-kraken.sh

echo
echo "Hit any key to install custom prometheus config for JVM metrics..."
read 
kubectl -n monitoring apply -f prometheus/servicemonitor.yaml 
kubectl -n monitoring apply -f prometheus/prometheusrule.yaml
kubectl -n monitoring apply -f prometheus/jvm-metrics-configmap.yaml 
