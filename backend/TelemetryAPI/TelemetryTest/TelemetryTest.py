import socket
import time

CAN_IDS = [105, 361, 389, 390, 393, 394, 401, 417, 512, 513, 528, 530, 532, 560, 561, 617, 624, 644, 645, 646, 647,
           648, 649, 650, 651, 656, 787, 819, 820, 848, 849, 850, 851, 873, 896, 912, 913, 914, 915, 916, 917, 1029,
           1030, 1072, 1153, 1155, 1157, 1158, 1159, 1280, 1281, 1282, 1297, 1298, 1377, 1378, 1385, 1638, 913, 915]

UDP_IP = "255.255.255.255"
UDP_PORT = 8998

class TelemetryTester:
    def __init__(self):
        # self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        # self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        # self.addr = ('127.0.0.1', 8998)  # 18.185.65.162
        # self.sock.settimeout(1)
        # self.packet_size = 10 * 2000
        # self.send_interval = 5

        self.sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)  # UDP
        interfaces = socket.getaddrinfo(host=socket.gethostname(), port=None, family=socket.AF_INET)
        self.allips = [ip[-1][0] for ip in interfaces]
        self.addr = ('255.255.255.255', 8998)  # 18.185.65.162
        self.sock.settimeout(1)
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        self.packet_size = 10 * 10
        self.send_interval = 5

    def sendall(self, _payload):
        # data = bytearray()
        # for can_id in CAN_IDS:
        #     can_msg = can_id.to_bytes(2, 'big') + _payload
        #     data += can_msg
        #     if len(data) >= self.packet_size:
        #         self.sock.sendto(data, self.addr)
        #         data = bytearray()
        # if len(data) > 0:
        #     self.sock.sendto(data, self.addr)

        data = bytearray()
        for can_id in CAN_IDS:
            can_msg = can_id.to_bytes(2, 'big') + _payload
            data += can_msg
            if len(data) >= self.packet_size:
                for ip in self.allips:
                    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)  # UDP
                    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
                    sock.bind((ip, 0))
                    sock.sendto(data, (UDP_IP, UDP_PORT))
                    sock.close()
                data = bytearray()
        if len(data) > 0:
            for ip in self.allips:
                sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)  # UDP
                sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
                sock.bind((ip, 0))
                sock.sendto(data, (UDP_IP, UDP_PORT))
                sock.close()

    def run(self):
        zeros = b'\x00\x00\x00\x00\x00\x00\x00\x00'
        fours = b'\x44\x44\x44\x44\x44\x44\x44\x44'
        eights = b'\x88\x88\x88\x88\x88\x88\x88\x88'
        cs = b'\xcc\xcc\xcc\xcc\xcc\xcc\xcc\xcc'
        fs = b'\xff\xff\xff\xff\xff\xff\xff\xff'
        wait_time = self.send_interval
        while True:
            self.sendall(zeros)
            time.sleep(wait_time)
            self.sendall(fours)
            time.sleep(wait_time)
            self.sendall(eights)
            time.sleep(wait_time)   
            self.sendall(cs)
            time.sleep(wait_time)
            self.sendall(fs)
            time.sleep(wait_time)
        # can_id = 624
        # can_msg1 = can_id.to_bytes(2, 'big') + b'\x44\x44\x44\x44\x44\x44\x44\x44'
        # can_msg2 = can_id.to_bytes(2, 'big') + b'\xff\xff\xff\xff\xff\xff\xff\xff'
        # while True:
        #     time.sleep(0.09)
        #     self.sock.sendto(can_msg1, self.addr)
        #     time.sleep(0.09)
        #     self.sock.sendto(can_msg2, self.addr)


if __name__ == '__main__':
    tester = TelemetryTester()
    tester.send_interval = 0.01  # sec
    try:
        tester.run()
    except Exception as e:
        print(e)
