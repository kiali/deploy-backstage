# deploy-backstage


# Install helm

```bash
sudo dnf install helm
```

# Install repos

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add backstage https://backstage.github.io/charts
helm repo add redhat-developer https://redhat-developer.github.io/rhdh-chart
```

# Deploy Backstage

```bash
make deploy
```

## Configure the image to deploy

### Default values
```bash
BACKSTAGE_REGISTRY ?= quay.io
BACKSTAGE_REPOSITORY ?= redhat-developer/backstage
BACKSTAGE_TAG ?= latest
```

| Helm Charts    | Description       | Repo                         |
|----------------|-------------------|------------------------------|
| Janus Showcase | Community         | janus-idp/backstage-showcase |
| RHDH           | Community Preview | redhat-developer/backstage   |
| RHDH           | RedHat            | rhdh/rhdh-hub-rhel9          |


Test a Showcase PR => Check your tag in [quay repo](https://quay.io/repository/janus-idp/backstage-showcase?tab=tags)

```bash
BACKSTAGE_REPOSITORY=janus-idp/backstage-showcase BACKSTAGE_TAG=<Your tag> make deploy
```
