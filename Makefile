SHELL=/bin/bash

# Configuration
CLUSTER_NAME ?= apps-crc.testing
HELM_NAME ?= kiali-backstage
NAMESPACE ?= backstage
CHART_NAME ?= redhat-developer/backstage

# Image configuration
BACKSTAGE_REGISTRY ?= quay.io
BACKSTAGE_REPOSITORY ?= redhat-developer/backstage
BACKSTAGE_TAG ?= latest

deploy:  
	@echo -e 'Installing Backstage:'
	@echo -e '-------------------------------------------------'
	@echo -e '\t Helm name: \e[1;39m${HELM_NAME}\e[0m'
	@echo -e '\t Namespace: \e[1;39m${NAMESPACE}\e[0m'		
	@echo -e '\t Cluster: \e[1;39m${CLUSTER_NAME}\e[0m'			
	@echo -e '\t Chart name: \e[1;39m${CHART_NAME}\e[0m'		
	@echo -e '\t Backstage image: \e[1;39m${BACKSTAGE_REGISTRY}\e[0m/\e[1;31m${BACKSTAGE_REPOSITORY}\e[0m:\e[1;32m${BACKSTAGE_TAG}\e[0m'	
	@echo -e '-------------------------------------------------'		
	helm install ${HELM_NAME} ${CHART_NAME} --create-namespace --namespace ${NAMESPACE} \
    --set global.clusterRouterBase=${CLUSTER_NAME} \
    --set upstream.backstage.image.registry=${BACKSTAGE_REGISTRY} \
    --set upstream.backstage.image.repository=${BACKSTAGE_REPOSITORY} \
    --set upstream.backstage.image.tag=${BACKSTAGE_TAG} \
    --values kiali.yaml

uninstall:
	@echo Uninstall Backstage with name ${HELM_NAME}
	helm uninstall ${HELM_NAME} ${REPO_BACKSTAGE} --namespace ${NAMESPACE}

update:
	@echo Updating yaml file
	./update_template.sh