# v;final

import network
from json import dumps
from socket import socket
from socket import AF_INET
from socket import SOCK_DGRAM
from time import sleep
from machine import Pin, UART

def csCalc(msg):
    
    cs = 0
    for byte in msg:
        cs = cs ^ byte
    return cs

def connect():
    
    #Connect to WLAN
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    wlan.connect(ssid, password)
    while wlan.isconnected() == False:
        print('Waiting for connection...')
        sleep(1)
    led = Pin("LED", Pin.OUT)
    led.on()

def radio_fireup(notreset):

    notreset.value(1)

ssid = "FRT_Areo"
password = "FRTfrec009"

########################### INIT ################################

##### WIFI CONNECT #####
connect()

##### UDP SOCKET #####
try:
    server = socket(AF_INET, SOCK_DGRAM) #ipv4 udp socket
    
except Exception as e:
    print(f"exception{e.__class__}     {e}")

###### RADIO_FIREUP ######
try:
    nrst = Pin(5, Pin.OUT)
    radio_fireup(nrst)

except Exception as e:
    print(f"exception{e.__class__}  {e}")

##### UART PORT INIT #####
while True:

    try:
        radio = UART(0, 256000)
        radio.init(256000, bits = 8, parity = None, stop = 1)

    except:
        continue

    # if no exception was found break the loop
    break

strength = b''
canid = []
payload = []
faulty = 0
########################## MAIN LOOP #################################

while True:
    
    ########### MSG READ ############
    try:
        
        # wait for start byte
        ans = radio.any()
        while (ans == 0):
            ans = radio.any()
            
        s = radio.read(1)
        while s != b'\x02':
            s = radio.read(1)

        cmd = radio.read(1) # 1byte cmd byte
        #print(cmd)
        length = radio.read(1) # + 1byte length byte
        #print(length)
        
        # storing CAN messages
        for i in range((int.from_bytes(length, 'big') - 1)/10):

            canid.append(radio.read(2)) # + CANID 2 byte
            payload.append(radio.read(8)) # + DATA 8 byte

        strength = radio.read(1) # 1 byte field strength
        cs = radio.read(1) # + 1 byte CS

    except Exception as e:
        faulty += 1
        #print(e)
        continue
    

    #################### BROADCAST #########################  
    try:
        
        msg = bytearray()
        msg += length
        
        for i in range(len(canid)):
        
            msg += canid[i]
            msg += payload[i]
        
        msg += strength
            
    except:
        pass
    
    try:
        csMsg = bytearray(msg)
        csMsg += b'\x02\x81'
            
        if csCalc(csMsg) != int.from_bytes(cs, 'big'):
            faulty = faulty + 1
            print(faulty)
            continue
        
    except Exception as e:
        faulty += 1
        #print(e)
        
    try:
        server.sendto(msg, ('255.255.255.255', 8999))
    except Exception as e:
        print(f"exception{e.__class__}     {e} ezitt")
    
    canid.clear()
    payload.clear()
    