KIALI_PACKAGE=@janus-idp/backstage-plugin-kiali
KIALI_BACKEND_PACKAGE=@janus-idp/backstage-plugin-kiali-backend-dynamic
YAML_TEMPLATE="./template/kiali.tmp.yaml"

#
# KIALI PACKAGE
#

KIALI_VERSION=$(npm view $KIALI_PACKAGE version)
npm pack $KIALI_PACKAGE@$KIALI_VERSION > /dev/null 2>&1
KIALI_PACKAGE=$KIALI_PACKAGE@$KIALI_VERSION
file=$(echo ${KIALI_PACKAGE:1} | sed -r 's/[\/@]+/-/g').tgz
KIALI_CHECKSUM=$(echo "sha512-$(cat $file | openssl dgst -sha512 -binary | openssl base64 -A)")
rm -rf $file

#
# KIALI BACKEND PACKAGE
#

KIALI_BACKEND_VERSION=$(npm view $KIALI_BACKEND_PACKAGE version)
npm pack $KIALI_BACKEND_PACKAGE@$KIALI_BACKEND_VERSION > /dev/null 2>&1
KIALI_BACKEND_PACKAGE=$KIALI_BACKEND_PACKAGE@$KIALI_BACKEND_VERSION
file=$(echo ${KIALI_BACKEND_PACKAGE:1} | sed -r 's/[\/@]+/-/g').tgz
KIALI_BACKEND_CHECKSUM=$(echo "sha512-$(cat $file | openssl dgst -sha512 -binary | openssl base64 -A)")
rm -rf $file

export KIALI_VERSION
export KIALI_CHECKSUM
export KIALI_BACKEND_VERSION
export KIALI_BACKEND_CHECKSUM

envsubst '${KIALI_VERSION} ${KIALI_CHECKSUM} ${KIALI_BACKEND_VERSION} ${KIALI_BACKEND_CHECKSUM}' < $YAML_TEMPLATE > ./kiali.yaml