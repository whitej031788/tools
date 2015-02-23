#!/usr/bin/python
import sys
import getopt
import pprint

from suds.client import Client

url = 'http://api101.magnetmail.net/mmapi.asmx?wsdl'
soapClient = Client(url)

print (soapClient)


result = soapClient.service.Authenticate('jwhite@realmagnet.com','meepins1')

authHead = soapClient.factory.create('mmAuthHeader')

authHead.sessionId = result['sessionId']
authHead.user_id = result['user_id']
soapClient.set_options(soapheaders=authHead)
args = {
    'user_id':result['user_id'],
    'recipient_id':1179917958
}
d = dict(user_id=result['user_id'],recipient_id='1179917958')
recID = 1179917958
UID = result['user_id']
print (str(recID) + "," + UID)
result = soapClient.service.getRecipientDetails(**d)
print (result)
