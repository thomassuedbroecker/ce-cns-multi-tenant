#!/bin/bash
########################################
# Create a file based on the environment variables
# given by the dockerc run -e parameter
########################################
cat <<EOF
window.VUE_APP_ROOT="${VUE_APP_ROOT}"
// used as 'environment' variables, 
// window.VUE_APP_ROOT="${}" // local
window.VUE_APP_WEPAPI="${VUE_APP_WEPAPI}"
// App ID related
// Single WebPage
window.VUE_APPID_CLIENT_ID="${VUE_APPID_CLIENT_ID}"
window.VUE_APPID_DISCOVERYENDPOINT="${VUE_APPID_DISCOVERYENDPOINT}"
EOF