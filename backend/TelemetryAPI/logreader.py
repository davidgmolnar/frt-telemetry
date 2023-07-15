import socket
from time import sleep

from cantools.database import load_file, errors

CAN1 = load_file('C:/Users/cupid/OneDrive/Asztali gép/DBC/DBC_2023/CAN1.dbc')
CAN2 = load_file('C:/Users/cupid/OneDrive/Asztali gép/DBC/DBC_2023/CAN2.dbc')

print_list = [
    "HV_Cell_ID"
]


def decode(can_msg):
    canid = int.from_bytes(can_msg[0:2], 'big')
    try:
        dict_read = CAN1.decode_message(canid, can_msg[2:10])
    except KeyError:
        try:
            dict_read = CAN2.decode_message(canid, can_msg[2:10])
        except errors.DecodeError:
            return {}
    return dict_read


def run(log_path: str, convert: bool = False):
    if convert:
        converted_file = open("converted.bin", 'ab')
    with open(log_path, 'rb') as file:
        while True:
            # format
            #    uint32 -> lenght
            #    length bytes -> payload
            #    uint64 -> timestamp ms
            length = int.from_bytes(file.read(4), 'big')
            payload = file.read(length)
            timestamp = int.from_bytes(file.read(8), 'big')
            if length == 0 and timestamp == 0:
                print('Finished')
                break
            offset = 0
            decoded = dict()
            while offset < length - 10:
                try:
                    decoded.update(decode(payload[offset:offset + 10]))
                    if convert:
                        converted_file.write(payload[offset:offset + 10] + timestamp.to_bytes(4, 'big'))
                    offset += 10
                except KeyError:
                    offset += 1
            for key in print_list:
                if key in decoded.keys():
                    print(f"{int(decoded[key])} - {timestamp}")


def replay(log_path: str):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)  # UDP
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
    with open(log_path, 'rb') as file:
        first = True
        prev_timestamp = None
        addr = ("255.255.255.255", 8998)
        while True:
            # format
            #    uint32 -> lenght
            #    length bytes -> payload
            #    uint64 -> timestamp ms
            length = int.from_bytes(file.read(4), 'big')
            payload = file.read(length)
            timestamp = int.from_bytes(file.read(8), 'big')
            if length == 0 and timestamp == 0:
                print('Finished')
                break
            if first:
                first = False
                prev_timestamp = timestamp
                sock.sendto(payload, addr)
            else:
                sleep((timestamp - prev_timestamp) / 1000)
                sock.sendto(payload, addr)
                prev_timestamp = timestamp


if __name__ == '__main__':
    # run("C:/Users/cupid/Downloads/PACSONYI.bin", convert=False)
    replay("C:/Users/cupid/Downloads/PACSONYI.bin")
