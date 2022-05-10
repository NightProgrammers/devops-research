Tekton CI
===

## Setup  tekton system

> practice accroding with following:
> - https://github.com/tektoncd/triggers/tree/main/docs/getting-started

WIP: should find a free kubernetes cluster service with dns able to run in github workflow, it should not need credit card.

###  Setup Pipeline

```bash
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
# or 
# kubectl apply --filename setup/pipeline.yaml
```
### Setup Trigger

```bash
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
# or 
# kubectl apply -f setup/trigger.yaml
kubectl apply --filename https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml
# or 
# kubectl apply -f setup/trigger-interceptors.yaml
```

### Setup cluster sec

```bash
kubectl apply --filename https://raw.githubusercontent.com/tektoncd/triggers/main/examples/rbac.yaml
# or
# kubectl apply -f setup/cluster-rolebinding.yaml

kubectl create namespace getting-started

kubectl apply --filename https://raw.githubusercontent.com/tektoncd/triggers/main/docs/getting-started/rbac/webhook-role.yaml
# or
# kubectl apply -f setup/webhook-rolebinding.yaml
```
### (Optional) Setup with tekton operator
or using operator to setup pipeline and trigger: https://github.com/tektoncd/operator

## Install the example resources

```bash
kubectl apply -f https://raw.githubusercontent.com/tektoncd/triggers/main/docs/getting-started/pipeline.yaml
# or 
# kubectl apply -f started/pipeline.yaml
kubectl apply -f https://raw.githubusercontent.com/tektoncd/triggers/main/docs/getting-started/triggers.yaml
# or
# kubectl apply -f started/triggers.yaml
```

### Setup ingress

```bash
kubectl apply -f started/task-create-ingress.yaml
kubectl apply -f started/taskRun-create-ingress.yaml
```

### Setup webhook

before: you should create a github personal access token as [following doc](https://github.com/tektoncd/triggers/blob/main/docs/getting-started/README.md#create-and-execute-the-ingress-and-webhook-tasks).

```bash
kubectl apply -f started/task-create-webhook.yaml

# set var GITHUB_TOKEN with github private token or replace `${GITHUB_TOKEN}` with real token value.
sed "s/<REPLACE_WITH_GITHUB_TOKEN>/${GITHUB_TOKEN}/g" started/secret-webhook.yaml | \
    kubectl -n getting-started apply -f -
sed started/taskRun-create-webhook.yaml "s/<GitHubOrg>/${GITHUB_ORG}/g;s/<GitHubUser>/${GITHUB_USER}/g;s/<GitHubRepo>/${GITHUB_REPO}/g;s/<ExternalDomain>/${EXTERNAL_DOMAIN}/g" | \
    kubectl -n getting-started apply -f -
```

### Test It

pls see [this](https://github.com/tektoncd/triggers/tree/main/docs/getting-started#run-the-completed-tekton-triggers-stack).

## Features

- [ ] retry/rerun
- [ ] 