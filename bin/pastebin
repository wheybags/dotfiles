#!/usr/bin/env python

# Requires http://wwwsearch.sourceforge.net/mechanize/

import mechanize
import sys
import os

if len(sys.argv) is not 2:
	print "Usage: %s filename\nuse - as filename for stdin" % sys.argv[0]
	os._exit(1)
	  
br = mechanize.Browser()
br.open("http://pastebin.com/")

br.select_form("myform")

if sys.argv[1] == "-":
	file = sys.stdin
else:
	file = open(sys.argv[1])
	br["paste_name"] = os.path.basename(sys.argv[1])

br["paste_code"] = str(file.read())

print br.submit().geturl() 
