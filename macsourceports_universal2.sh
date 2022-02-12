# game/app specific values
export APP_VERSION="1.2.0"
export ICONSDIR=""
export ICONSFILENAME="OpenJKDF2"
export PRODUCT_NAME="OpenJKDF2"
export EXECUTABLE_NAME="OpenJKDF2"
export PKGINFO="APPLJKDF2"
export COPYRIGHT_TEXT="Star Wars Jedi Knight: Dark Forces II © 1997 LucasArts. All rights reserved."

#constants
source ../MSPScripts/constants.sh

rm -rf ${BUILT_PRODUCTS_DIR}

#because this port does so much of the packaging itself all we need to do is run the script
./distpkg_macos.sh

mkdir ${BUILT_PRODUCTS_DIR}
mv ${PRODUCT_NAME}_universal.app ${BUILT_PRODUCTS_DIR}/${WRAPPER_NAME}

#sign and notarize
"../MSPScripts/sign_and_notarize.sh" "$1"