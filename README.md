# gitpod-for-kubernetes

This project is meant to show a simple example `.gitpod.yml` with Dockerfile for developing/managing a Kubernetes cluster. In this case, the `.gitpod.yml` is targeting connecting to an AWS EKS cluster.

Generic K8S tools included:
- helm
- kubectl
- kubent
- k9s

Tools specific to this cluster's implementation:
- flux
- glooctl
- awscli

The `.gitpod.yml` assumes you have AWS credentials for setting the kube context and that network routes exist to connect to the cluster
