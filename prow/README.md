PROW
===

[Prow](https://github.com/kubernetes/test-infra/tree/master/prow) is a CI and automatic workflow project based github, it came from kubernetes projects.

## Deploy

Here using a local kubernetes cluster created by [kind](https://kind.sigs.k8s.io/)

> reference from prow's [deploy doc](https://github.com/kubernetes/test-infra/blob/master/prow/getting_started_deploy.md)

The office prow deploy doc is about GCould and other cloud providers, it's lacked of self manual k8s cluster guide.
Here deploy with local k8s cluster with s3 sample config.

### prerequirements:

- golang 1.18+.
- [Helm](https://github.com/helm/helm/releases) CLI tool
- local k8s cluster.