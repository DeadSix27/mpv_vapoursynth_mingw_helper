#!/usr/bin/env python
import sys
import fileinput
if len(sys.argv)<3:
	exit()
pcFile = sys.argv[1]
installDir = sys.argv[2]
filedata = None
with open(pcFile, 'r') as file :
  filedata = file.read()
filedata = filedata.replace('[[prefix]]', installDir)
with open(pcFile, 'w') as file:
  file.write(filedata)