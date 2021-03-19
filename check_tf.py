
# CHECK TF PY

# Show TensorFlow+Keras versions, devices, CPUs and GPUs
# for human inspection

import tensorflow as tf
import keras
from tensorflow.python.client import device_lib
print("TF    version: " + tf.__version__)
print("Keras version: " + keras.__version__)
print(device_lib.list_local_devices())
