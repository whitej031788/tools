#!/usr/bin/python
import sys
import getopt
import pprint

try:
    from lxml import etree
except ImportError:
    try:
        import xml.etree.cElementTree as etree
    except ImportError:
         print("Failed to load etree")
"""
root = etree.Element("accessLevels")
accessLevel = etree.SubElement(root,"accessLevel")
loginId = etree.SubElement(accessLevel,"loginId")
settingName = etree.SubElement(accessLevel,"settingName")
mailUserId = etree.SubElement(accessLevel,"mailUserId")
value = etree.SubElement(accessLevel,"value")
loginId.text = sys.argv[1]
value.text = '1'
"""
def createXML():
    pp = pprint.PrettyPrinter(indent=2)
    infile = open(sys.argv[1],'r')
    accessLevel = etree.Element("accessLevel")
    for line in infile:
        lines = line.split(',')
        mailUser = lines[0]
        login = lines[1]
        mailUser = mailUser.rstrip()
        login = login.rstrip()
        loginId = etree.SubElement(accessLevel,"loginId")
        settingName = etree.SubElement(accessLevel,"settingName")
        mailUserId = etree.SubElement(accessLevel,"mailUserId")
        value = etree.SubElement(accessLevel,"value")
        loginId.text = login
        value.text = '1'
        settingName.text = 'TrackingAccess'
        mailUserId.text = mailUser
        print(etree.tostring(accessLevel, pretty_print=True))
        accessLevel.remove(loginId)
        accessLevel.remove(settingName)
        accessLevel.remove(mailUserId)
        accessLevel.remove(value)
        loginId = etree.SubElement(accessLevel,"loginId")
        settingName = etree.SubElement(accessLevel,"settingName")
        mailUserId = etree.SubElement(accessLevel,"mailUserId")
        value = etree.SubElement(accessLevel,"value")
        loginId.text = login
        value.text = '1'
        settingName.text = 'UnsubAccess'
        mailUserId.text = mailUser
        print(etree.tostring(accessLevel, pretty_print=True))
        accessLevel.remove(loginId)
        accessLevel.remove(settingName)
        accessLevel.remove(mailUserId)
        accessLevel.remove(value)
        loginId = etree.SubElement(accessLevel,"loginId")
        settingName = etree.SubElement(accessLevel,"settingName")
        mailUserId = etree.SubElement(accessLevel,"mailUserId")
        value = etree.SubElement(accessLevel,"value")
        loginId.text = login
        value.text = '1'
        settingName.text = 'JobsAccess'
        mailUserId.text = mailUser
        print(etree.tostring(accessLevel, pretty_print=True))
        accessLevel.remove(loginId)
        accessLevel.remove(settingName)
        accessLevel.remove(mailUserId)
        accessLevel.remove(value)

    infile.close()

print('<?xml version="1.0"?>')
print('<accessLevels>')
createXML()
print('</accessLevels>')
