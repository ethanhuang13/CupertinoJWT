COMMON_CRYPTO_DIR="${SDKROOT}/usr/include/CommonCrypto"
if [ -f "${COMMON_CRYPTO_DIR}/module.modulemap" ]
then
echo "CommonCrypto already exists, skipping"
exit 0
fi

# This if-statement means we'll only run the main script if the CommonCryptoModuleMap directory doesn't exist
# Because otherwise the rest of the script causes a full recompile for anything where CommonCrypto is a dependency
# Do a "Clean Build Folder" to remove this directory and trigger the rest of the script to run
if [ -d "${BUILT_PRODUCTS_DIR}/CommonCryptoModuleMap" ]; then
echo "${BUILT_PRODUCTS_DIR}/CommonCryptoModuleMap directory already exists, so skipping the rest of the script."
exit 0
fi

mkdir -p "${BUILT_PRODUCTS_DIR}/CommonCryptoModuleMap"
cat <<EOF > "${BUILT_PRODUCTS_DIR}/CommonCryptoModuleMap/module.modulemap"
module CommonCrypto [system] {
    header "${SDKROOT}/usr/include/CommonCrypto/CommonCrypto.h"
    export *
}
EOF