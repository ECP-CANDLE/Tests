
# SETUP TESTS
# Setup batch of tests

echo "THIS: $THIS"
PATH=$THIS:$PATH

source $THIS/utils.sh

echo "PWD:  $( /bin/pwd )"

source $THIS/py-settings.sh

python $THIS/check_tf.py
echo

source $THIS/find-benchmarks.sh
