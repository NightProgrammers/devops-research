Argo events
===

accroding to:

- https://argoproj.github.io/argo-events/quick_start/


## Summary

[Architecture](https://argoproj.github.io/argo-events/concepts/architecture/)

![Architecture](https://argoproj.github.io/argo-events/assets/argo-events-architecture.png)

## Install

1. setup workflows
   - setup workflows namespace:
     > `kubectl create namespace argo`
   - setup workflows components:
     > `kubectl -n argo apply -f https://raw.githubusercontent.com/argoproj/argo-workflows/master/manifests/install.yaml`
2. setup events
   - create events namespace 
     > `kubectl create namespace argo-events`
   - create events CRD and role bindings,configmaps, etc...
     > `kubectl -n argo-events apply -f https://raw.githubusercontent.com/argoproj/argo-events/master/manifests/install.yaml`
   - setup events components components - event bus:
     > `kubectl -n argo-events apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml`
   - setup event source components, such as webhook:
     > `kubectl -n argo-events apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/event-sources/webhook.yaml`
   - setup event sensor components:
     1. create service account with role binding:
        ```bash
        # sensor rbac 
        kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/master/examples/rbac/sensor-rbac.yaml
        # workflow rbac
        kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/master/examples/rbac/workflow-rbac.yaml 
        ```
     2. create sensor, such as webhook:
        > `kubectl apply -n argo-events -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/sensors/webhook.yaml`

## Test

flow is:

```
\ --->
http request 
    \
    webhook event source pod
        \
        event bus
            \
            webhook sensor
                \
                k8s
                    \
                    create a argo workflow resource
```                    

1. trigger a webhook request:
   ```bash
   kubectl -n default create job sendwebhook --image=curlimages/curl -- curl \
    -X POST \
    -d '{"message":"this is my first webhook"}' \
    -H "Content-Type: application/json" \
    http://webhook-eventsource-svc.argo-events:12000/example
   kubectl -n default wait job/sendwebhook --for=condition=completed --timeout=1m 
   ```
2. wait the workflow
   > `kubectl -n argo-events wait workflows --all --for=condition=Completed --timeout=1m`
