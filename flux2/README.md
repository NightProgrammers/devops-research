Flux2 CD practice
===

Document Start from [here](https://fluxcd.io/docs/get-started/).
Training at kotato

## deploy

### flux CLI

Install by bash or download release binary.

### flux service

Please fork it.

```bash
export GITHUB_TOKEN=<github private token>
export GITHUB_REPOSITORY_OWNER=<github org>
flux check --pre
flux bootstrap github \
    --owner=${GITHUB_REPOSITORY_OWNER} \
    --repository=devops-research \
    --branch=main \
    --path=flux2/multi-clusters/clusters/staging
```

### multi clusters and tenants

- different stages should be deliveried to different clusters.
- different tenants should be deliveried into different namespaces.
- multi tenants supports:
  - seperate with different repos of branches.
  - seperate with different dirs with file ownwers enabled, here I using it.

ref: 
- https://github.com/fluxcd/flux2-kustomize-helm-example
- https://github.com/fluxcd/flux2-multi-tenancy

## watched delivery git repo struct

> recommand monorepo approach,constraction can be found [here](https://fluxcd.io/docs/guides/repository-structure/#delivery-management).

structure:
```bash
├── multi-clusters # for practice multi clusters.
│   ├── apps
│   │   ├── base
│   │   │   └── podinfo
│   │   ├── prod
│   │   └── staging
│   ├── clusters
│   │   ├── prod
│   │   └── staging
│   └── infrastructure
│       ├── nginx
│       ├── redis
│       └── sources
|
├── multi-tenants # for practice multi tennats with multi clusters.
│   ├── clusters
│   │   ├── prod
│   │   └── staging
│   ├── infrastructure
│   │   ├── kyverno # tennats control components.
│   │   └── kyverno-policies # tennats control policies.
│   ├── teams
│   │   └── dev-team
│   │       ├── base # team apps.
│   │       ├── prod
│   │       └── staging
│   └── tenants
│       ├── base
│       │   └── dev-team
│       ├── prod
│       └── staging
└── scripts # script for CI.
```

If you want to get summary structure of kustomization of or other deploy kind, you can using `flux tree` command, for an example:
```bash
flux tree kustomization flux-system
```
the output will be: 
```
Kustomization/flux-system/flux-system
├── Kustomization/flux-system/apps
└── Kustomization/flux-system/infrastructure
    ├── Namespace/istio-system
    ├── Kustomization/flux-system/istio-gateway
    │   ├── MetricTemplate/istio-system/error-rate
    │   ├── MetricTemplate/istio-system/latency
    │   └── Gateway/istio-system/public-gateway
    ├── Kustomization/flux-system/istio-operator
    │   ├── CustomResourceDefinition/istiooperators.install.istio.io
    │   ├── Namespace/istio-operator
    │   ├── ServiceAccount/istio-operator/istio-operator
    │   ├── ClusterRole/istio-operator
    │   ├── ClusterRoleBinding/istio-operator
    │   ├── Service/istio-operator/istio-operator
    │   └── Deployment/istio-operator/istio-operator
    └── Kustomization/flux-system/istio-system
        ├── ServiceAccount/istio-system/prometheus
        ├── ClusterRole/prometheus
        ├── ClusterRoleBinding/prometheus
        ├── ConfigMap/istio-system/prometheus
        ├── Service/istio-system/prometheus
        ├── Deployment/istio-system/prometheus
        ├── HelmRelease/istio-system/flagger
        │   ├── ServiceAccount/flagger
        │   ├── ClusterRole/flagger
        │   ├── ClusterRoleBinding/flagger
        │   └── Deployment/flagger
        ├── HelmRelease/istio-system/flagger-grafana
        │   ├── ConfigMap/flagger-grafana-dashboards
        │   ├── ConfigMap/flagger-grafana-datasources
        │   ├── ConfigMap/flagger-grafana-providers
        │   ├── Service/flagger-grafana
        │   └── Deployment/flagger-grafana
        ├── IstioOperator/istio-system/istio-default
        └── HelmRepository/istio-system/flagger

```

## Continue testing for CD repo changes.

- All changes should be applied by MR/PR.
- Setup CI pipeline to testing MR/PR changes.

> TODO: can it be done only with flux tool kit?