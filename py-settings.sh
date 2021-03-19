
# PY SETTINGS

# Report Python settings for human inspection
# Assumes that THIS has been set

source $THIS/utils.sh

echo "PYTHON: $( which_check python )"
echo "PYTHON VERSION: $( python --version 2>&1 )"

log_path PYTHONPATH
show PYTHONHOME PYTHONUSERBASE

