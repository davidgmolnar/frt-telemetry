import cantools

CAN1 = cantools.db.load_file('../DBC_2023/CAN1.dbc')
CAN2 = cantools.db.load_file('../DBC_2023/CAN2.dbc')

payload_1 = b'\x12\x34\x56\x78\x9a\xbc\xde\xf0'
payload_2 = b'\x45\x7c\x13\x7b\x41\x63\xae\x7a'

payload_3 = b'\x12\x34\x00\x00\x9a\xbc\xde\xf0'
payload_4 = b'\x45\x7c\x00\x10\x41\x63\xae\x7a'

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


if __name__ == '__main__':
    # endian tests
    # endian_json_1 = dict()
    # endian_json_2 = dict()
    # can_id = 617
    # endian_json_1.update(decode(can_id.to_bytes(2, 'big') + payload_1))
    # endian_json_2.update(decode(can_id.to_bytes(2, 'big') + payload_2))
    # can_id = 560
    # endian_json_1.update(decode(can_id.to_bytes(2, 'big') + payload_1))
    # endian_json_2.update(decode(can_id.to_bytes(2, 'big') + payload_2))
    # can_id = 1030
    # endian_json_1.update(decode(can_id.to_bytes(2, 'big') + payload_1))
    # endian_json_2.update(decode(can_id.to_bytes(2, 'big') + payload_2))
    # can_id = 647  # signed
    # endian_json_1.update(decode(can_id.to_bytes(2, 'big') + payload_1))
    # endian_json_2.update(decode(can_id.to_bytes(2, 'big') + payload_2))
    # can_id = 819
    # endian_json_1.update(decode(can_id.to_bytes(2, 'big') + payload_1))
    # endian_json_2.update(decode(can_id.to_bytes(2, 'big') + payload_2))
    # print(f"-------------\nendian_json_1\n{pprint(endian_json_1)}\n-------------")
    # print(f"-------------\nendian_json_2\n{pprint(endian_json_2)}\n-------------")

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
