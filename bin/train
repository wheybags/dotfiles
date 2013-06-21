#!/usr/bin/env python

import urllib
import urllib2
import re
from BeautifulSoup import BeautifulSoup
import sys

# Return input string, justified and padded within num chars
# Positive num for left, and negative for right justify
def justify(num, string):
	if len(string) > num:
		return string[0:num]
	if num > 0:
		return string + " " * (num - len(string))
	else:
		return " " * (- num - len(string)) + string

def get_url(station):
	url = 'http://www.irishrail.ie/station_updates.jsp'
	values = {'station1' : station}
	data = urllib.urlencode(values)
	req = urllib2.Request(url, data)
	response = urllib2.urlopen(req)
	
	try:
		return "http://www.irishrail.ie/" +\
			re.search("realtime/station_details.jsp\\?ref=.*p=1",\
			response.read()).group()
	except:
		return None

def get_dorts(url):
	soup = BeautifulSoup(urllib2.urlopen(url).read())
	soup = soup.find('div').find('div') # The train <table>s are within two divs

	dorts = []
	
	# Normally there will be one table for each direction
	for s in soup.findAll('table', recursive = False):

		trainlist = []
		# All trains are in tr elements with no attributes
		for train in s.findAll(lambda tag: tag.name == "tr" and not tag.attrs, recursive = False):
			stuff = []
			first = True
			for part in train.findAll('td'):
				if not first:
					stuff.append(str(part)[4:-5]) # strips the td tags
				else:
					first = False
				
			trainlist.append(stuff)
		
		dorts.append(trainlist)

	return dorts

def print_dorts(dorts):
	longest_origin = len("Origin")
	longest_dest = len("Dest")
	for x in dorts:
		for y in x:
			if len(y[0]) > longest_origin:
				longest_origin = len(y[0])
			if len(y[1]) > longest_dest:
				longest_dest = len(y[1])


	print justify(longest_origin, "Origin"),
	print justify(longest_dest, "Dest"),
	print justify(5, "Type"),
	print justify(5, "Sch"),
	print justify(5, "ETA"),
	print justify(8, "Due In"),
	print "Latest Info"
	print

	for x in dorts:
		for y in x:
			print justify(longest_origin, y[0]),
			print justify(longest_dest, y[1]),
			print justify(5, y[2]),
			print justify(5, y[3]),
			print justify(5, y[4]),
			print justify(8, y[5]),
			print y[6]
		
		print


def main():
	if len(sys.argv) < 2:
		print "Usage: " + sys.argv[0] + " <station name> [station name...]"
		exit(1)

	url = get_url(" ".join(sys.argv[1:]))
	if not url:
		print "No station found"
		exit(2)

	dorts = get_dorts(url)
	print_dorts(dorts)



if __name__ == "__main__":
	main()
