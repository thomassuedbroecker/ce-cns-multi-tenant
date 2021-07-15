#!/bin/bash

########################################
# Create a file based on the environment variables
# given by the dockerc run -e parameter
########################################
cat <<EOF
window.VUE_APP_ROOT="${VUE_APP_ROOT}"
window.VUE_APP_KEYCLOAK="${VUE_APP_KEYCLOAK}"
window.VUE_APP_WEBAPI="${VUE_APP_WEBAPI}"
window.VUE_REDIRECT_URL="${VUE_REDIRECT_URL}"
window.VUE_REALM="${VUE_REALM}"
EOF