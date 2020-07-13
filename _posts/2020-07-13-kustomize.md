---
layout: post
title:  "Let's Kustomize"
author: Sandeep
categories: [ Kubernetes, Tutorial, Kustomize ]
image: assets/images/kust/1.png
featured: true
hidden: true
comments: false
---

## Kustomize
<hr style="height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block">

> Kustomize is a standalone tool to customize Kubernetes objects through a kustomization file. Kustomize lets you customize raw, template-free YAML files for multiple purposes, leaving the original YAML untouched and usable as is. 

`Kustomize` is a very opinionated tool. If you are interested to know more about it, you can listen/subscribe to this [Kubernetes Podcast from Google](https://kubernetespodcast.com/) by `Adam Glick` and `Craig Box`. 

<figure>
  <figcaption>Source: <a href="https://kubernetespodcast.com/episode/007-kustomize-with-a-k/">"Kubernetes podcast from Google #007"</a></figcaption>
  <audio style="width:100%;" height="45" controls src="https://kubernetespodcast.com/episodes/KPfGep007.mp3"></audio>
</figure>

Let's try to understand Kustomize using an example. Personally, Kustomize and Helm solves different problems and if you seriously think about patching the current kubernetes applications, Kustomize is the best tool. You can do the same with Helm and if you like lot of templating, Helm is what you need.

You can watch the below talk about limits of Helm.

<p><iframe style="width:100%;" height="315" src="https://www.youtube.com/embed/pRG47EQ5OAg?rel=0&amp;showinfo=0" frameborder="0" allowfullscreen></iframe></p>

## Kustomize - Helm Chart
<hr style="height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block">

Lets Kustomize a Helm Chart. I took [datadog helm chart](https://github.com/helm/charts/tree/master/stable/datadog) for this blog. But you can take any helm chart that you want. Base idea will remain the same.

Here is my example repo for this blog [`Kustomization of datadog Helm Chart`](https://github.com/sandeeplamb/kustomization-datadog)

![walking]({{ site.baseurl }}/assets/images/kust/2.png)

## Kustomize - Its Patching
<hr style="height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block">

There are 2 main directories that Kustomize uses i.e. `bases` and `overlays`.

`bases` will contain the base/raw form of Helm chart converted into a plain YAML file which can be easily understandable by `kustomization`.

`overlays` will contain the actual patches that you will put on `bases`. There will be different patches as per your needs. Here I took an example of patches for `dev` and `prod` environments.

### Kustomize - bases dissection
<hr style="height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block">

[bases](https://github.com/sandeeplamb/kustomization-datadog/tree/master/k8s/bases) contains the main helm chart for datadog.

```python
├── Makefile ------------------> use to template the helm chart into yaml format
├── datadog.values.yaml -------> is the values files use to tempaltise datadog helm chart
├── datadog.yaml --------------> is the actual kustomize manifest file
├── kustomization.yaml --------> contains the templated helm chart manifests in yaml format
├── transformer-common.yaml ---> transformer used by kustomize to override images
├── transformer-images.yaml ---> transformer used by kustomize to add labels
├── transformer-patches.yaml --> transformer used by kustomize to patche k8s resources
└── vendor --------------------> actual helm chart here
```

#1. <ins>`Makefile`</ins> <br> 
Makefile have just 1 update command which will be used to create datadog manifest file again.
If a new version of datadog helm chart released, just fetch the helm chart in `vendor/stable` directory and update `Makefile`

```sh
(⎈ |k8s) ] cat Makefile
update:
    helm3 template \
          datadog \
          --namespace=monitoring \
          --values datadog.values.yaml \
          vendor/stable/datadog-2.3.14/ \
          > datadog.yaml
```

#2. <ins>`datadog.values.yaml`</ins> <br> 
The actual values for `datadog helm chart` are present in this file. These values can be default values from helm chart.

```yaml
datadog:
  apiKey: ""
  appKey: ""
  clusterName: "eks-dev-cluster-1"
  kubeStateMetricsEnabled: true
  tags:
    - "region: eu-east-1"
    - "customer: xyz"
clusterAgent:
  enabled: true
```

#3. <ins>`datadog.yaml`</ins> <br> 
This file contain all the manifest files after templating the helm chart. Kustomize will use this file to create further resources of kubernetes.

```yaml
---
# Source: datadog/templates/agent-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: datadog-cluster-agent
  labels:
...
---
...
---
...
---
```

#4. <ins>`kustomization.yaml`</ins> <br> 
This file contains resource files names from where kustomize will create manifests. More details about kustomize docs [here](https://kubernetes-sigs.github.io/kustomize/)

```yaml
resources:
- ./datadog.yaml

transformers:
- ./transformer-common.yaml
- ./transformer-patches.yaml
- ./transformer-images.yaml
```

#5. <ins>`transformer-common.yaml`</ins> <br> 
The labels transformer adds labels to the metadata/labels field for all resources.

```yaml
---
apiVersion: builtin
kind: LabelTransformer
metadata:
  name: stub
labels:
  app.kubernetes.io/name: kube-state-metrics
  app.kubernetes.io/instance: "datadog"
fieldSpecs:
- path: metadata/labels
  create: true
```

#6. <ins>`transformer-images.yaml`</ins> <br> 
The default images transformer updates the specified image key values found in paths that include containers and initcontainers sub-paths.

```yaml
apiVersion: builtin
kind: ImageTagTransformer
metadata:
  name: image-quay-coreos
imageTag:
  name: quay.io/coreos/kube-state-metrics
  newName: my-registry.servers.xyz.com/mirrors/quay.io/coreos/kube-state-metrics
  newTag: v1.9.5
```

#7. <ins>`transformer-patches.yaml`</ins> <br> 
Patch Transformer can patch the k8s manifests and can replace/remove contents. Below `PatchTransformer` will replace the image for Deployment and remove the labels imposed by helm chart.

```yaml
---
apiVersion: builtin
kind: PatchTransformer
metadata:
  name: helm-cleaner-kube-state
target:
  group: apps
  version: v1
  kind: Deployment
  namespace: monitoring
  name: datadog-kube-state-metrics
patch: |-
  - op: replace
    path: /spec/template/spec/containers/0/image
    value: "my-registry.servers.xyz.com/mirrors/quay.io/coreos/kube-state-metrics:v1.9.5"
  - op: remove
    path: /spec/template/spec/containers/0/resources/limits/cpu
  - op: remove
    path: "/metadata/labels/helm.sh~1chart"
  - op: remove
    path: "/metadata/labels/app.kubernetes.io~1managed-by"
```

#8. <ins>`vendor`</ins> <br> 
This directory contains the actual helm chart from upstream stable repository.

```python
(⎈ |k8s) ] tree -d vendor/
vendor/
└── stable
    └── datadog-2.3.14
        ├── charts
        │   └── kube-state-metrics
        │       └── templates
        ├── ci
        ├── docs
        └── templates
```

### Kustomize - overlays dissection
<hr style="height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block">

`Overlays` can be divided into environment based directories. Every environment contains patches relevant to it. Patching becomes easy and we can add manifest per environment very easily using a pipeline.

`secrets` can be added which later can become env variables or volumes in Pod using configmap/secret.

```python
(⎈ |k8s) ] tree -d
.
├── dev
│   ├── patches
│   └── secrets
└── prod
    ├── patches
    └── secrets
```

### Kustomize - Run it
<hr style="height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block">

To run the `kustomize`, we change directory to `overlays` environment and apply it.

```sh
[⎈ k8s ] cd k8s/overlays/dev/
[⎈ k8s ] kustomize build .
[⎈ k8s ] kustomize build . | kubectl apply -f -
[⎈ k8s ] 
[⎈ k8s ] 
[⎈ k8s ] cd k8s/overlays/prod/
[⎈ k8s ] kustomize build .
[⎈ k8s ] kustomize build . | kubectl apply -f -
```

### Kustomize - improvisation
<hr style="height:3px;border-width:0;color:gray;background-color:gray;border-style: inset;display: block">

- Use [kapp](https://get-kapp.io/) tool with kustomize for deployment
- Use [sops](https://github.com/mozilla/sops) to encrypt secrets
- Use pipelines to install patches per environment of overlays

![walking]({{ site.baseurl }}/assets/images/8.jpg)

## Reference lists


