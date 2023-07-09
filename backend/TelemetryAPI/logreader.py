from cantools.database import load_file, errors

CAN1 = load_file('DBC_2023/CAN1.dbc')
CAN2 = load_file('DBC_2023/CAN2.dbc')

print_list = [
    "VDC_Yaw_Control_P"
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
                    decoded.update(decode(payload[offset:offset+10]))
                    if convert:
                        converted_file.write(payload[offset:offset+10] + timestamp.to_bytes(4, 'big'))
                    offset += 10
                except KeyError:
                    offset += 1
            for key in print_list:
                if key in decoded.keys():
                    print(f"{bin(int(decoded[key] / 25)).rjust(10,' ')} - {int(decoded[key] / 25)} - {timestamp}")


if __name__ == '__main__':
    run("telemetry_log.bin", convert=True)
