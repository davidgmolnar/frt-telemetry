import socket
import time
from json import loads

import cantools

CAN1 = cantools.db.load_file('../DBC_2023/CAN1.dbc')
CAN2 = cantools.db.load_file('../DBC_2023/CAN2.dbc')


general_payloads = [
    b'\x12\x34\x56\x78\x9a\xbc\xde\xf0',
    b'\x45\x7c\x13\x7b\x41\x63\xae\x7a'
]

multiplexed_payloads = [
    b'\x01\x34\xd0\x00\x9a\xbc\xde\xf0',
    b'\x02\x7c\x60\x10\x41\x63\xae\x7a'
]

CAN_IDS = [105, 361, 389, 390, 393, 394, 401, 417, 512, 513, 528, 530, 532, 560, 561, 617, 624, 644, 645, 646, 647,
           648, 649, 650, 651, 656, 787, 819, 820, 848, 849, 850, 851, 873, 896, 912, 914, 916, 917, 1029,
           1030, 1072, 1153, 1155, 1157, 1158, 1159, 1280, 1281, 1282, 1297, 1298, 1377, 1378, 1385, 1638]

MULTIPLEX_IDS = [915, 913]

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
target_addr = ('127.0.0.1', 6666)
local_addr = ('127.0.0.1', 7777)
sock.bind(local_addr)
sock.settimeout(1)


def decode(can_msg):
    canid = int.from_bytes(can_msg[0:2], 'big')
    try:
        dict_read = CAN1.decode_message(canid, can_msg[2:10])
    except KeyError:
        try:
            dict_read = CAN2.decode_message(canid, can_msg[2:10])
        except KeyError:
            return {}
    return dict_read


def pprint(data: dict):
    return "\n".join([f"{key}: {val}" for key, val in data.items()])


def manualTests():
    # endian tests
    endian_json_1 = dict()
    endian_json_2 = dict()
    can_id = 617
    endian_json_1.update(decode(can_id.to_bytes(2, 'big') + payload_1))
    endian_json_2.update(decode(can_id.to_bytes(2, 'big') + payload_2))
    can_id = 560
    endian_json_1.update(decode(can_id.to_bytes(2, 'big') + payload_1))
    endian_json_2.update(decode(can_id.to_bytes(2, 'big') + payload_2))
    can_id = 1030
    endian_json_1.update(decode(can_id.to_bytes(2, 'big') + payload_1))
    endian_json_2.update(decode(can_id.to_bytes(2, 'big') + payload_2))
    can_id = 647  # signed
    endian_json_1.update(decode(can_id.to_bytes(2, 'big') + payload_1))
    endian_json_2.update(decode(can_id.to_bytes(2, 'big') + payload_2))
    can_id = 819
    endian_json_1.update(decode(can_id.to_bytes(2, 'big') + payload_1))
    endian_json_2.update(decode(can_id.to_bytes(2, 'big') + payload_2))
    print(f"-------------\nendian_json_1\n{pprint(endian_json_1)}\n-------------")
    print(f"-------------\nendian_json_2\n{pprint(endian_json_2)}\n-------------")

    # multiplex tests
    multiplex_json_1 = dict()
    multiplex_json_2 = dict()
    can_id = 915

    try:
        multiplex_json_1.update(decode(can_id.to_bytes(2, 'big') + payload_3))
    except Exception as e:
        print(f"1 Nop")
    try:
        multiplex_json_2.update(decode(can_id.to_bytes(2, 'big') + payload_4))
    except Exception as e:
        print(f"2 Nop")
    print(f"-------------\nendian_json_1\n{pprint(multiplex_json_1)}\n-------------")
    print(f"-------------\nendian_json_2\n{pprint(multiplex_json_2)}\n-------------")


def automatedTests():
    i = 0
    for payload in general_payloads:
        print(f"Round {i}")
        i += 1
        for can_id in CAN_IDS:
            py_decoded = decode(can_id.to_bytes(2, 'big') + payload)
            sock.sendto(can_id.to_bytes(2, 'big') + payload, target_addr)
            data, addr = sock.recvfrom(10000)
            dart_decoded = loads(data.decode('ascii'))

            for signal in py_decoded.keys():
                if py_decoded[signal] != dart_decoded[signal]:
                    print(f"ERROR {signal}  -  Python gave {py_decoded[signal]}, dart gave {dart_decoded[signal]}")
                else:
                    pass
                    # print(f"INFO {signal} matches")

    print("Dikk")


def multiplexTests():
    i = 0
    for payload in multiplexed_payloads:
        print(f"Round {i}")
        i += 1
        for can_id in MULTIPLEX_IDS:
            py_decoded = decode(can_id.to_bytes(2, 'big') + payload)
            sock.sendto(can_id.to_bytes(2, 'big') + payload, target_addr)
            data, addr = sock.recvfrom(10000)
            dart_decoded = loads(data.decode('ascii'))

            try:
                multiplex_group = py_decoded["Multiplexer"]
            except KeyError:
                multiplex_group = py_decoded["NDCDCMultiplexer"]

            for signal in py_decoded.keys():
                if signal in ["Multiplexer", "NDCDCMultiplexer"]:
                    continue
                py_signal = py_decoded[signal]
                try:
                    dart_signal = dart_decoded[signal + f" m{multiplex_group}"]
                except KeyError:
                    dart_signal = dart_decoded[signal]
                if py_signal != dart_signal:
                    print(f"ERROR {signal}  -  Python gave {py_signal}, dart gave {dart_signal}")
                else:
                    pass
                    # print(f"INFO {signal} matches")

    print("Dikk")


if __name__ == '__main__':
    # manualTests()
    automatedTests()
    multiplexTests()
