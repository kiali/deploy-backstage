KIALI_PACKAGE=@janus-idp/backstage-plugin-kiali
KIALI_BACKEND_PACKAGE=@janus-idp/backstage-plugin-kiali-backend-dynamic
YAML_TEMPLATE="./template/kiali.tmp.yaml"

KIALI_VERSION=$(cat kiali.yaml | grep $KIALI_PACKAGE@ | cut -d'@' -f3 | sed "s/'//g")
KIALI_BACKEND_VERSION=$(cat kiali.yaml | grep $KIALI_BACKEND_PACKAGE@ | cut -d'@' -f3 | sed "s/'//g")
KIALI_CHECKSUM=$(grep -A1 $KIALI_PACKAGE@ kiali.yaml | tail -n1 | cut -d':' -f2 | sed 's/ //g')
KIALI_BACKEND_CHECKSUM=$(grep -A1 $KIALI_BACKEND_PACKAGE@ kiali.yaml | tail -n1 | cut -d':' -f2 | sed 's/ //g')
#
# KIALI PACKAGE
#
echo -e "\nChecking updates for \e[1;39m$KIALI_PACKAGE\e[0m...\n"
KIALI_NEW_VERSION=$(npm view $KIALI_PACKAGE version)
if [ "$KIALI_VERSION" = "$KIALI_NEW_VERSION" ]; then
    echo -e "There is \e[1;39mnot\e[0m a new version for \e[1;39m$KIALI_PACKAGE\e[0m"
else
    echo -e "We found a new \e[1;32m$KIALI_NEW_VERSION\e[0m for \e[1;39m$KIALI_PACKAGE\e[0m."
    echo -e "Upgrading from \e[1;31m$KIALI_VERSION\e[0m to \e[1;32m$KIALI_NEW_VERSION\e[0m."
    KIALI_VERSION=$KIALI_NEW_VERSION
    KIALI_PACKAGE=$KIALI_PACKAGE@$KIALI_VERSION
    npm pack $KIALI_PACKAGE > /dev/null 2>&1
    file=$(echo ${KIALI_PACKAGE:1} | sed -r 's/[\/@]+/-/g').tgz
    KIALI_CHECKSUM=$(echo "sha512-$(cat $file | openssl dgst -sha512 -binary | openssl base64 -A)")
    rm -rf $file
fi

#
# KIALI BACKEND PACKAGE
#


echo -e "\nChecking updates for \e[1;39m$KIALI_BACKEND_PACKAGE\e[0m...\n"
KIALI_NEW_BACKEND_VERSION=$(npm view $KIALI_BACKEND_PACKAGE version)
if [ "$KIALI_BACKEND_VERSION" = "$KIALI_NEW_BACKEND_VERSION" ]; then
    echo -e "There is \e[1;39mnot\e[0m a new version for \e[1;39m$KIALI_BACKEND_PACKAGE\e[0m"
else
    echo -e "We found a new \e[1;32m$KIALI_NEW_BACKEND_VERSION\e[0m for \e[1;39m$KIALI_BACKEND_PACKAGE\e[0m."
    echo -e "Upgrading from \e[1;31m$KIALI_BACKEND_VERSION\e[0m to \e[1;32m$KIALI_NEW_BACKEND_VERSION\e[0m."
    KIALI_BACKEND_VERSION=$KIALI_NEW_BACKEND_VERSION
    KIALI_BACKEND_PACKAGE=$KIALI_BACKEND_PACKAGE@$KIALI_BACKEND_VERSION
    npm pack $KIALI_BACKEND_PACKAGE > /dev/null 2>&1
    file=$(echo ${KIALI_BACKEND_PACKAGE:1} | sed -r 's/[\/@]+/-/g').tgz
    KIALI_BACKEND_CHECKSUM=$(echo "sha512-$(cat $file | openssl dgst -sha512 -binary | openssl base64 -A)")
    rm -rf $file
fi

export KIALI_VERSION
export KIALI_CHECKSUM
export KIALI_BACKEND_VERSION
export KIALI_BACKEND_CHECKSUM

envsubst '${KIALI_VERSION} ${KIALI_CHECKSUM} ${KIALI_BACKEND_VERSION} ${KIALI_BACKEND_CHECKSUM}' < $YAML_TEMPLATE > ./kiali.yaml