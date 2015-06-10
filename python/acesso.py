#!/usr/bin/python
import SoftLayer
import pprint

from pprint import pprint as pp
user=''
api=''
dc = SoftLayer_Location_Datacenter
 
client = SoftLayer.Client(username=user, api_key=api, endpoint_url=SoftLayer.API_PUBLIC_ENDPOINT)
allVlans = client.getDatacenters()
pprint.pprint(dc)

