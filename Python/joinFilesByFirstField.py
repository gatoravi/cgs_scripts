#Avinash Ramu, TGI, WUSTL
#Often we have files where the first column is a key for eg chr:pos,
#this script will attempt to join those files using the primary-key.

#!/bin/env python

import sys
import pandas
from glob import iglob

for f in iglob("*.altrefVAF"):
  print f

concat = pandas.concat((pandas.read_csv(f, sep = "\t") for f in iglob("*.altrefVAF")), axis=1)
print concat.head()
