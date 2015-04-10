#!/bin/python

import OSC
import time, os, binascii
import random

#OSC stuff
client = OSC.OSCClient()
client.connect(('127.0.0.1', 57120))
msg = OSC.OSCMessage()
msg.setAddress("/smplr")
bgtrackmsg = OSC.OSCMessage()
bgtrackmsg.setAddress("/bgtrack")
bgisplaying = True
#print "OSC setup"

#Set the filename and open the file
filename = '/Users/aarntz/Documents/thesis/sonivi/logtest.txt'
file = open(filename,'rb')

#Find the size of the file and move to the end
st_results = os.stat(filename)
print st_results
st_size = st_results[6]
print st_size
file.seek(st_size)

#A line has two sides

#helper functions to do hex conversions
def listtohex(listofchar):
    hexlist = [binascii.hexlify(x) for x in listofchar]
    return hexlist

#Hard coded keys

#normToInsASCII = ["i", "I", "a", "A", "o", "O", "c", "C", "s", "S"]
normToIns = ['69', '49', '61', '41', '6f', '4f', '63', '43', '73', '53']

#normToContASCII = ["f", "F"]
normToCont = ['66', '46']

#Set the global flag for playing or not
mode = 'NORMAL'

def changemode(ks, md):
    global mode
    global previouskey

    if md == 'NORMAL' and ks in normToCont:
        mode = 'CONTINUED'

    if md == 'CONTINUED':
        mode = 'NORMAL'

    if md == 'NORMAL' and ks in normToIns:
        mode = 'INSERT'
        playoneshot(ks)
        togglebgtrackmsg()

    if md == 'INSERT' and ks == '1b':
        mode = 'NORMAL'
        playoneshot(ks)
        togglebgtrackmsg()

def togglebgtrackmsg():
    global bgisplaying
    if bgisplaying is True:
        bgtrackmsg.clearData()
        bgtrackmsg.append([0])
        client.send(bgtrackmsg)
        bgisplaying = False
    else:
        bgtrackmsg.clearData()
        bgtrackmsg.append([1])
        client.send(bgtrackmsg)
        bgisplaying = True

def playoneshot(keystroke):
    msg.clearData()
    msg.append(keystroke)
    client.send(msg)

while 1:
    where = file.tell()
    line = file.read()#.decode(encoding='utf8')
    if not line:
        file.seek(where)
    else:
        global mute
        global mode

        keystroke = binascii.hexlify(line);
        #keystroke = binascii.b2a_qp(line)
        #print keystroke
        currentMode = mode

        if currentMode == 'NORMAL':
            msg.clearData()
            msg.append(keystroke)
            #print unichr(ord("\\x" + msg.message))
            print msg.message
            client.send(msg)
            changemode(keystroke, currentMode)

        if currentMode == 'INSERT':
            print "MUTED"
            changemode(keystroke, currentMode)

        if currentMode == 'CONTINUED':
            msg.clearData()
            msg.append(keystroke)
            print msg.message
            client.send(msg)
            changemode(keystroke, currentMode)
