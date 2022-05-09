PROW
===

[Prow](https://github.com/kubernetes/test-infra/tree/master/prow) is a CI and automatic workflow project based github, it came from kubernetes projects.

## Deploy

Here using a local kubernetes cluster created by [kind](https://kind.sigs.k8s.io/)

> reference from prow's [deploy doc](https://github.com/kubernetes/test-infra/blob/master/prow/getting_started_deploy.md)

The office prow deploy doc is about GCould and other cloud providers, it's lacked of self manual k8s cluster guide.
Here deploy with local k8s cluster with s3 sample config.

### Prerequirements:

- golang 1.18+.
- local k8s cluster, you can set up with kind tool.
- [Helm](https://github.com/helm/helm/releases) CLI tool

### Deploy with kubectl

using kubectl to apply k8s yaml files.
1. create cluster role binding, pls see [this](https://github.com/kubernetes/test-infra/blob/master/prow/getting_started_deploy.md#create-cluster-role-bindings).
2. create secrets, pls see [this](https://github.com/kubernetes/test-infra/blob/master/prow/getting_started_deploy.md#create-the-github-secrets)

3. apply CRD from [here](https://raw.githubusercontent.com/kubernetes/test-infra/master/config/prow/cluster/prowjob-crd/prowjob_customresourcedefinition.yaml)
   ```bash
   kubectl apply --server-side=true -f https://raw.githubusercontent.com/kubernetes/test-infra/master/config/prow/cluster/prowjob-crd/prowjob_customresourcedefinition.yaml
   ```
4. download deployment yaml from [here](https://raw.githubusercontent.com/kubernetes/test-infra/master/config/prow/cluster/starter/starter-s3.yaml)
5. update deployment yaml content:
   1. The GitHub app cert by replacing the `<<insert-downloaded-cert-here>>` string
   2. The GitHub app id by replacing the `<<insert-the-app-id-here>>` string
   3. The hmac token by replacing the `<< insert-hmac-token-here >>` string
   4. The domain by replacing the `<< your-domain.com >>` string
   5. Your GitHub organization(s) by replacing the `<< your_github_org >>` string
   6. The S3 minio user by replacing the `<<CHANGE_ME_MINIO_ROOT_USER>>` string
   7. The S3 minio password by replacing the `<<CHANGE_ME_MINIO_ROOT_PASSWORD>>` string
6. create namespace: `prow`, `prod`, `test-pods` in cluster.
7. deploy prow deployment and service:
   ```bash
   kubectl apply -f starter-s3.yaml
   ```

If failed in image pull from dockerhub, you should create docker registry credential and update deployment yaml accroding to [this](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/)

### deploy with kustomization `TODO`

### deploy with helm chart `WIP`

chart dir: `<repo root dir>/charts/prow`