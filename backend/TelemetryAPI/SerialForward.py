import serial
import socket

UDP_IP = "255.255.255.255"
UDP_PORT = 8998

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)  # UDP
interfaces = socket.getaddrinfo(host=socket.gethostname(), port=None, family=socket.AF_INET)
allips = [ip[-1][0] for ip in interfaces]
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)

to_send = bytearray()

with serial.Serial('COM9', 460800, timeout=1) as ser:
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
            for byte in msg:
                to_send.append(byte)
            #print("RSSI" + twos_comp(rssi, 8).__str__())
            if len(to_send) >= 100:
                for ip in allips:
                    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)  # UDP
                    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
                    sock.bind((ip,0))
                    sock.sendto(to_send, (UDP_IP, UDP_PORT))
                    sock.close()
                to_send = bytearray()
        except Exception as e:
            if e.__class__ == KeyboardInterrupt:
                exit(0)
            else:
                print(e)
        