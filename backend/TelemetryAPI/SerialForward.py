import socket

from json import dumps

import serial.tools.list_ports
from serial import Serial
from cantools.database import load_file

UDP_IP = "255.255.255.255"
UDP_PORT = 8998

# sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)  # UDP
interfaces = socket.getaddrinfo(host=socket.gethostname(), port=None, family=socket.AF_INET)
allips = [ip[-1][0] for ip in interfaces]
# sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
# sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

CAN1 = load_file('DBC_2022/CAN1_matrix_2022.dbc')
CAN2 = load_file('DBC_2022/CAN2_matrix_2022.dbc')

payload = dict()

# serial.tools.list_ports.comports()

with Serial('COM5', 230400, timeout=1) as ser:
    while True:
        try:
            startByte = ser.read()
            while startByte != b'\x7e':
                startByte = ser.read()
            message = ser.read(7)

            length = message[1]
            rssi = message[5]  # ez is mehet majd a kliensnek
            buffer = ser.read(length - 5)
            print(rssi)
            payload.clear()
            for i in range(0, len(buffer), 10):
                try:
                    payload.update(CAN1.decode_message(int.from_bytes(buffer[i: i + 2], 'big'), buffer[i + 2: i + 10]))
                except KeyError:
                    try:
                        payload.update(CAN2.decode_message(int.from_bytes(buffer[i: i + 2], 'big'), buffer[i + 2: i + 10]))
                    except KeyError:
                        print("Nincs is ilyen can id wtf")
                except Exception as e:
                    print(f"Decode exception {e.__class__}: {e}")
            for ip in allips:
                sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)  # UDP
                sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
                sock.bind((ip, 0))
                sock.sendto(dumps(payload), (UDP_IP, UDP_PORT))
                sock.close()

        except Exception as e:
            print(f"hupsz {e.__class__}: {e}")
