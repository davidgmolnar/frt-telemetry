import socket
from datetime import datetime, timedelta

from json import dumps

import serial.tools.list_ports
from serial import Serial
from cantools.database import load_file

UDP_IP = "255.255.255.255"
UDP_PORT = 8998

# sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)  # UDP
interfaces = socket.getaddrinfo(
    host=socket.gethostname(), port=None, family=socket.AF_INET)
allips = [ip[-1][0] for ip in interfaces]
# sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
# sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

CAN1 = load_file('C:\FRT\Elektro\DBC_2023/CAN1.dbc')
CAN2 = load_file('C:\FRT\Elektro\DBC_2023/CAN2.dbc')

payload = dict()

# serial.tools.list_ports.comports()


def twos_comp(val, bits):
    """compute the 2's complement of int value val"""
    if (val & (1 << (bits - 1))) != 0:  # if sign bit is set e.g., 8bit: 128-255
        val = val - (1 << bits)         # compute negative value
    return val


def decode(buffer):
    for i in range(0, len(buffer), 10):
        try:
            payload.update(CAN1.decode_message(int.from_bytes(
                buffer[i: i + 2], 'big'), buffer[i + 2: i + 10]))
        except KeyError:
            try:
                payload.update(CAN2.decode_message(int.from_bytes(
                    buffer[i: i + 2], 'big'), buffer[i + 2: i + 10]))
            except KeyError:
                pass
                # print("Nincs is ilyen can id")
        except Exception as e:
            print(f"Decode exception {e.__class__}: {e}")
    # if "APPS2_ADC" in payload.keys():
    #     print("APPS1 " + payload["APPS1_ADC"].__str__() + " APPS2 " + payload["APPS2_ADC"].__str__())
    return payload


sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM,
                     socket.IPPROTO_UDP)  # UDP
sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

time = datetime.now()
bytecnt = 0
ne_ddosoljal = 10

with Serial('COM10', 468000, timeout=1) as ser:
    i = 0
    while True:
        try:
            startByte = ser.read()
            while startByte != b'\x02':
                startByte = ser.read()
            command = ser.read()
            if command != b'\x81':
                continue
            length = ser.read()
            msg = ser.read(int.from_bytes(length, 'big') - 1)
            rssi = ser.read()
            #print("RSSI" + twos_comp(rssi, 8).__str__())
            payload.update(decode(msg))
            sock.sendto(dumps(payload).encode(), (UDP_IP, UDP_PORT))

            # bytecnt += 15
            # if datetime.now() - time > timedelta(seconds=1):
            #     time = datetime.now()
            #     print(bytecnt)
            #     bytecnt = 0
        except Exception as e:
            print(e)