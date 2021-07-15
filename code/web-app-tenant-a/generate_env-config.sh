#!/bin/bash
########################################
# Create a file based on the environment variables
# given by the dockerc run -e parameter
########################################
cat <<EOF
window.VUE_APP_ROOT="${VUE_APP_ROOT}"
window.VUE_TENANT_A="${VUE_TENANT_A}"
window.VUE_TENANT_B="${VUE_TENANT_B}"
EOF