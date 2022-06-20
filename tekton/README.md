Tekton CI
===

## Setup tekton system

> practice according with [following doc](https://github.com/tektoncd/triggers/tree/main/docs/getting-started).
> Also you can setup with [Tekton Operator](https://github.com/tektoncd/operator)

###  1. Setup Pipeline

> REF: https://github.com/tektoncd/pipeline/blob/main/docs/install.md

```bash
kubectl apply -f setup/pipeline/release.yaml
# or
# kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
```
### 2. Setup Trigger

> REF: https://tekton.dev/docs/triggers/install/

```bash
kubectl apply -f setup/trigger/release.yaml
kubectl apply -f setup/trigger/interceptors.yaml
# or
# kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/release.yaml
# kubectl apply -f https://storage.googleapis.com/tekton-releases/triggers/latest/interceptors.yaml
```

### 3. Setup Dashboard

> REF: https://tekton.dev/docs/dashboard/install/

```bash
kubectl apply -f setup/dashboard/release.yaml
# or
# kubectl apply -f https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml
```


## Getting Started

> All using the namespace `getting-started`.

### Create the namespace

```bash
kubectl create namespace getting-started
```

### Setup security

```bash
kubectl -n getting-started apply \
  -f started/setup/admin-role.yaml \
  -f started/setup/clusterrolebinding.yaml \
  -f started/setup/webhook-role.yaml

# or
# kubectl -n getting-started apply \
#     -f https://raw.githubusercontent.com/tektoncd/triggers/main/docs/getting-started/rbac/admin-role.yaml \
#     -f https://raw.githubusercontent.com/tektoncd/triggers/main/docs/getting-started/rbac/clusterrolebinding.yaml \
#     -f started/setup/webhook-role.yaml 
```

**TIP:** role defines in `https://raw.githubusercontent.com/tektoncd/triggers/main/docs/getting-started/rbac/webhook-role.yaml` was configured with `extension` as the api group, but it should be `networking.k8s.io` in new kubernets version, so I updated it.


### Install example resources

> REF: https://github.com/tektoncd/triggers/tree/v0.20.0/docs/getting-started#install-the-example-resources


```bash
kubectl apply -n getting-started -f started/resources/tasks
kubectl apply -n getting-started -f started/resources/pipelines
kubectl apply -f started/resources/triggers.yaml
```

### Setup ingress

> You can using [ultrahook tool](https://www.ultrahook.com/) to provider a public webhook DNS, and forward github webhook requests to you local ingress when you have none domain names.
> set `EXTERNAL_DOMAIN` env to you ultrabook sub github domain.

```bash
kubectl apply -n getting-started -f started/ingress/task-create-ingress.yaml
# before you run it, you should check and consider replace the `ExternalDomain` param's value. 
# default `test.io`.
kubectl apply -n getting-started -f started/ingress/taskRun-create-ingress.yaml
```

### Setup webhook

> you can also set it with browser manually.

before: you should create a github personal access token as [following doc](https://github.com/tektoncd/triggers/blob/main/docs/getting-started/README.md#create-and-execute-the-ingress-and-webhook-tasks).

```bash
kubectl apply -n getting-started -f started/webhook/task-create-webhook.yaml

# set var GITHUB_TOKEN with github private token or replace `${GITHUB_TOKEN}` with real token value.
sed "s/<REPLACE_WITH_GITHUB_TOKEN>/${GITHUB_TOKEN}/g" started/webhook/secret-webhook.yaml | kubectl -n getting-started apply -f -
sed "s/<GitHubOrg>/${GITHUB_ORG}/g;s/<GitHubUser>/${GITHUB_USER}/g;s/<GitHubRepo>/${GITHUB_REPO}/g;s/<ExternalDomain>/${EXTERNAL_DOMAIN}/g" started/webhook/taskRun-create-webhook.yaml | kubectl -n getting-started apply -f -
```

### Test It

Please see [this](https://github.com/tektoncd/triggers/tree/main/docs/getting-started#run-the-completed-tekton-triggers-stack).

## Features

- [x] retry/rerun
  - [x] retry task run or pipeline run from dashboard.
