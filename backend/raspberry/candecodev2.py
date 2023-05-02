from json import dumps
from socket import socket, AF_INET, SOCK_DGRAM, IPPROTO_UDP, SOL_SOCKET, SO_BROADCAST
from cantools.database import load_file
import logging
import time

def twos_comp(val, bits):
    
    # compute the 2's complement of int value val
    if (val & (1 << (bits - 1))) != 0: # if sign bit is set e.g., 8bit: 128-255
        val = val - (1 << bits)        # compute negative value
    return val

picoUdp = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP) #ipv4 udp socket
picoUdp.setsockopt(SOL_SOCKET, SO_BROADCAST, 1) # enable broadcast
picoUdp.bind(("", 8999)) # listen on 8999 port

formatLog = "%(asctime)s: %(message)s"
logging.basicConfig(format = formatLog, level = logging.INFO, datefmt = "%H:%M:%S")

CAN1 = load_file("CAN1.dbc")
CAN2 = load_file("CAN2.dbc")

while True:

    data = bytearray()
    try:
        data, addr = picoUdp.recvfrom(1024)
        #logging.info("readSocketThread  : data \n\t%s\nreceived", data)
        length = data[0] - 1 # -rssi
        #print(length)
    except Exception as e:
        logging.info("readSocketThread   : exception thrown:\n\t%s", e)
        pass
    
    d = dict()

    print("length = " + hex(length))

    for i in range(int(length/10)):
        try:
            #print(data[i+1:i+3])
            #print(hex(int.from_bytes(data[i*10+1 : i*10+3], 'big')))
            d.update(CAN1.decode_message(int.from_bytes(data[i*10+1 : i*10+3], 'big'), data[i*10+3 : i*10+11])) # canid, data 
        except:
            try:
                d.update(CAN2.decode_message(int.from_bytes(data[i*10+1 : i*10+3], 'big'), data[i*10+3 : i*10+11]))
            except:
                d["error"] = 8
        print(''.join(format(x, '02x') for x in data[i*10+1 : i*10+3]))

    d["rssi"] = twos_comp(data[len(data) - 1], 8)
    
    #logging.info("decodeCanThread   : \n\t%s\nradio message handled as\n\t%s", data, d)

    try:
        picoUdp.sendto(dumps(d).encode("ascii"), ("255.255.255.255", 8998))
        logging.info("broadcastJsonThread   : dict\n\t%s\nbroadcast", d)
    except Exception as e:
        pass
        #logging.info("broadcastJsonThread   : exception thrown:\n\t%s", e)