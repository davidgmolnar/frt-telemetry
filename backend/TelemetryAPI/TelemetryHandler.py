import asyncio
import json
import socket
import time
import cantools
import websockets

from influxdb_client import InfluxDBClient, Point, WritePrecision
from influxdb_client.client.write_api import SYNCHRONOUS
from influxdb_client.client.write.point import _append_time
from multiprocessing import Process, Queue
from queue import Empty, Full
from datetime import datetime

import TelemetryUtils as Utils
from TelemetryTest.TelemetryTest import TelemetryTester


STOP_QUEUE = Queue()
STOP_QUEUE.maxsize = 1

SOCK_QUEUE1 = Queue()
SOCK_QUEUE1.maxsize = 10000

SOCK_QUEUE2 = Queue()
SOCK_QUEUE2.maxsize = 10000

DICT_QUEUE1 = Queue()
DICT_QUEUE1.maxsize = 10000

DICT_QUEUE2 = Queue()
DICT_QUEUE2.maxsize = 10000

CAN1 = cantools.db.load_file('DBC_2022/CAN1_matrix_2022.dbc')
CAN2 = cantools.db.load_file('DBC_2022/CAN2_matrix_2022.dbc')
MULTIPLEXED_SIGNALS = [913, 915]

DATA_QUEUE = Queue()
DATA_QUEUE.maxsize = 10000
# REMAP_SETUP = [
#     ["Bosch_yaw_rate", "BoschYaw", None, None],
#     ["Vectornav_yaw_rate_rear_value", "VectornavYawRear", None, None],
#     ["Xavier_n_updates_last_resample", "XavierUpdates", None, None],
#     ["Yaw_Rate_Rear", "DynamicsYawRear", None, None],
#     ["v_x", "DynamicsVelocityX", None, 3.6],
#     ["v_y", "DynamicsVelocityY", None, 3.6],
#     ["AccX_Rear", "DynamicsAccelXRear", None, None],
#     ["AccY_Rear", "DynamicsAccelYRear", None, None],
#     ["sc_latch_place_of_error", "SCPlaceOfError", None, None],
#     ["sc_latch", "SCLatch", None, None],
#     ["AMK2_Torque_Limit_Positive", "AMK2TorqueLimit+", None, None],
#     ["AMK2_Torque_Limit_Negative", "AMK2TorqueLimit-", None, None],
#     ["AMK1_Torque_Limit_Positive", "AMK1TorqueLimit+", None, None],
#     ["AMK1_Torque_Limit_Negative", "AMK1TorqueLimit-", None, None],
#     ["VDC_Yaw_Control_Weight_Selector", "VDCYawControlWeight", None, None],
#     ["Brake_pressure_rear_ADC", "BPSRearADC", None, None],
#     ["Brake_pressure_front_ADC", "BPSFrontADC", None, None],
#     ["Brake_pressure_rear_validity", "BPSRearValidity", None, None],
#     ["Brake_pressure_front_validity", "BPSFrontValidity", None, None],
#     ["Brake_pressure_rear", "BPSRear", None, None],
#     ["Brake_pressure_front", "BPSFront", None, None],
#     ["Brake_force_validity", "BFSValidity", None, None],
#     ["Brake_Force_sensor", "BFS", None, None],
#     ["STA2_position", "STA2Pos", None, None],
#     ["STA1_position", "STA1Pos", None, None],
#     ["APPS2_posiition", "APPS2Pos", None, None],
#     ["APPS1_position", "APPS1Pos", None, None],
#     ["EPOS_Torque_actual_value", "EPOSTorque", None, None],
#     ["EPOS_Position_actual_value", "EPOSPosition", None, None],
#     ["Acc_Front_YawRate", "AccFrontYaw", None, None],
#     ["Acc_Front_RollRate", "AccFrontRoll", None, None],
#     ["Acc_Front_AccX", "AccFrontAccelX", None, None],
#     ["Acc_Front_AccY", "AccFrontAccelY", None, None],
#     ["AMK4_TorqueLimitPositive", "AMK4TorqueLimit+", None, None],
#     ["AMK4_TorqueLimitNegative", "AMK4TorqueLimit-", None, None],
#     ["AMK3_TorqueLimitPositive", "AMK3TorqueLimit+", None, None],
#     ["AMK3_TorqueLimitNegative", "AMK3TorqueLimit-", None, None],
#     ["Dashboarrd_heartbeat", "DashboardHeartbeat", None, None]
# ]

ORG = "BME-FRT"
BUCKET = "Telemetry_bucket"
TOKEN = "jM694-j3ECWPkG5whhEtP3NxoWZB5F833jo4AJAS_YHVlAO5vbAzvqMxwfuo8KQ2l9g1dGAjkWd2omE9uB1Eqg=="

CONNECTED = set()
CONNECTED_HOSTS = set()


# TODO load balance


def readSock(_stop_queue, _sock_queue1, _sock_queue2):   # THREAD
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM) as sock:
        sock_addr = ('127.0.0.1', 8998)  # 172.31.1.148
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        sock.bind(sock_addr)
        sock.settimeout(0.0001)
        while True:
            # if _stop_queue.qsize() > 0:
            #     break
            try:
                buffer, addr = sock.recvfrom(1000)  # CAN üzenetenként
                try:
                    # print("bytes read {}".format(len(buffer)))
                    for i in range(0, len(buffer), 10):
                        try:
                            _sock_queue1.put_nowait(buffer[i: i + 10])
                            _sock_queue2.put_nowait(buffer[i: i + 10])
                        except IndexError:
                            print("Zozó egy buzi")
                    i = 0
                except Full:
                    print("Sock queue full")
                    pass  # TODO wait and retry
            except socket.timeout:
                pass  # TODO ha sokszor lép be ide akkor sleepeljen és ne darálja a procit
            except Exception as e:
                print(f"Socketex {e}")
                try:
                    _stop_queue.put_nowait("PLACEHOLDER")
                except Full:  # Ha valaki már leállt akkor mindegy is
                    pass
                break


def decodeCan(can, multiplexed, _stop_queue, _sock_queue, _dict_queue, _data_queue):   # THREAD
    data = []
    batch_limit = 50
    while True:
        # if _stop_queue.qsize() > 0:
        #     break
        try:
            can_msg = _sock_queue.get_nowait()
            can_id = int.from_bytes(can_msg[0:2], 'big')
            if can_id in multiplexed:
                continue
            try:
                dict_read = can.decode_message(can_id, can_msg[2:10])
                try:
                    _dict_queue.put_nowait(dict(dict_read))
                except Full:
                    print("Dict Queue Full")
                    pass  # TODO wait and retry

                for key, value in dict_read.items():
                    data.append(f"telemetry_signals {key}={float(value)} {_append_time(datetime.utcnow(), WritePrecision.NS)}")
                try:
                    if len(data) >= batch_limit:
                        _data_queue.put_nowait(list(data))
                        data.clear()
                except Full:
                    print("Data Queue Full")
                    pass  # TODO wait and retry
            except KeyError:
                pass
        except Empty:
            pass  # TODO ha sokszor lép be ide akkor sleepeljen és ne darálja a procit
        except Exception as e:
            print(e)
            try:
                _stop_queue.put_nowait("PLACEHOLDER")
            except Full:  # Ha valaki már leállt akkor mindegy is
                pass
            break


# def reformat(remap_setup, can1, can2, multiplexed, _stop_queue, _dict_queue, _data_queue):   # THREAD
#     remap = Utils.reformatInit(remap_setup, can1, can2, multiplexed)  # TODO ennek így már elég csak egy canből beinitelnie
#     data = []
#     batch = 0
#     batch_limit = 40
#     while True:
#         if _stop_queue.qsize() > 0:
#             break
#         try:
#             dict_read = _dict_queue.get_nowait()
#             db_time_of_msg = dict_read['_db_timestamp']
#             for key, value in dict_read.items():
#                 if key != "_db_timestamp":
#                     key, value = Utils.reMap(remap, key, value)
#                     data.append(f"telemetry_signals {key}={float(value)} {db_time_of_msg}")  # ez legyen dict
#             try:
#                 if batch >= batch_limit:
#                     _data_queue.put_nowait(list(data))
#                     data.clear()
#                     batch = 0
#                 else:
#                     batch += 1
#             except Full:
#                 print("Data Queue full")  # TODO retry / retry attempt limit
#         except Empty:
#             pass  # TODO ha sokszor lép be ide akkor sleepeljen és ne darálja a procit
#         except Exception as e:
#             print(e)
#             try:
#                 _stop_queue.put_nowait("PLACEHOLDER")
#             except Full:  # Ha valaki már leállt akkor mindegy is
#                 pass
#             break

# async def handler(websocket):
#     buf = dict()
#     check_command_interval = 100
#     cnt = 100
#     print("belép")
#     while True:
#         if STOP_QUEUE.qsize() > 0:
#             break
#         try:
#             if cnt >= check_command_interval:
#                 data = await websocket.recv()  # itt lehet különböző kéréseket definiálni a backend felé
#                 cnt = 0
#             try:
#                 buf = DICT_QUEUE2.get_nowait()
#                 buf.update(DICT_QUEUE1.get_nowait())
#                 await websocket.send(json.dumps(buf))
#             except Empty:
#                 if len(buf) > 0:
#                     await websocket.send(json.dumps(buf))
#                 else:
#                     await websocket.send("")  # mindenképp válaszolni kell mert egyébként összefossa magát
#             cnt += 1
#             time.sleep(0.001)
#         except Exception as e:
#             print("meghalok")
#             print(e)
#             try:
#                 pass  # ez úgy tűnik tudja resetelni magát
#                 # STOP_QUEUE.put_nowait("PLACEHOLDER")
#             except Full:  # Ha valaki már leállt akkor mindegy is
#                 pass
#             break


async def streamData(dict_queue1, dict_queue2):  # THREAD
    buf = dict()
    while True:
        buf.clear()
        await asyncio.sleep(0.001)
        try:
            buf = dict_queue1.get_nowait()
        except Empty:
            pass
        try:
            buf.update(dict_queue2.get_nowait())
        except Empty:
            pass
        if len(CONNECTED) == 0 or len(buf) < 1:
            if len(CONNECTED) == 0:
                print("No connections to send to, sleeping 0.1 sec")
            if len(buf) < 1:
                print("Nothing to send, sleeping 0.1 sec")
            await asyncio.sleep(0.1)
        else:
            data = json.dumps(buf)
            websockets.broadcast(CONNECTED, data)


async def join(websocket):
    msg = await websocket.recv()
    if f"{websocket.host}:{websocket.port}" not in CONNECTED_HOSTS:
        CONNECTED.add(websocket)
        CONNECTED_HOSTS.add(f"{websocket.host}:{websocket.port}")
    print(f"{websocket.host}:{websocket.port} joined")
    print(f'{len(CONNECTED)} connections')
    try:
        await websocket.wait_closed()
    finally:
        try:
            CONNECTED.remove(websocket)
        except KeyError:
            pass
        CONNECTED_HOSTS.remove(f"{websocket.host}:{websocket.port}")
        print(f"{websocket.host}:{websocket.port} left")


def main(dict_queue1, dict_queue2):
    # async with websockets.serve(join, "127.0.0.1", 8990, ping_interval=None):  # 172.31.1.148
    #     await streamData(dict_queue1, dict_queue2)
    with socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP) as sock:  # UDP
        sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
        buf = dict()
        while True:
            buf.clear()
            try:
                buf = dict_queue1.get_nowait()
            except Empty:
                pass
            try:
                buf.update(dict_queue2.get_nowait())
            except Empty:
                pass
            if len(buf) < 1:
                print("Nothing to send, sleeping 0.1 sec")
                time.sleep(0.1)
            else:
                data = json.dumps(buf).encode('ascii')
                sock.sendto(data, ("255.255.255.255", 8990))


def sendtoflutter(dict_queue1, dict_queue2):  # THREAD
    # asyncio.run(main(dict_queue1, dict_queue2))
    main(dict_queue1, dict_queue2)


def upload(token, org, bucket, _stop_queue, _data_queue):   # THREAD
    with InfluxDBClient(url="http://localhost:8086", token=token, org=org) as client:
        batch = []
        batch_limit = 100
        # write_api = client.write_api(write_options=SYNCHRONOUS)
        while True:
            if _stop_queue.qsize() > 0:
                break
            try:
                data = _data_queue.get_nowait()
                if len(batch) >= batch_limit:
                    # write_api.write(bucket, org, data)
                    batch.clear()
                else:
                    batch[0:0] = data
            except Empty:
                pass  # TODO ha sokszor lép be ide akkor sleepeljen és ne darálja a procit
            except Exception as e:
                print(e)
                try:
                    _stop_queue.put_nowait("PLACEHOLDER")
                except Full:  # Ha valaki már leállt akkor mindegy is
                    pass
                break


if __name__ == '__main__':
    socket_thread = Process(target=readSock, args=(STOP_QUEUE, SOCK_QUEUE1, SOCK_QUEUE2))
    decode_thread1 = Process(target=decodeCan, args=(CAN1, MULTIPLEXED_SIGNALS, STOP_QUEUE, SOCK_QUEUE1, DICT_QUEUE1, DATA_QUEUE))
    decode_thread2 = Process(target=decodeCan, args=(CAN2, MULTIPLEXED_SIGNALS, STOP_QUEUE, SOCK_QUEUE2, DICT_QUEUE2, DATA_QUEUE))
    connection_handler = Process(target=sendtoflutter, args=(DICT_QUEUE1, DICT_QUEUE2))
    # upload_thread = Process(target=upload, args=(TOKEN, ORG, BUCKET, STOP_QUEUE, DATA_QUEUE))

    socket_thread.start()
    decode_thread1.start()
    decode_thread2.start()
    connection_handler.start()
    # upload_thread.start()

    threads = [socket_thread,
               decode_thread1,
               decode_thread2,
               connection_handler,
               # upload_thread
               ]

    try:
        if True:  # TEST MODE
            tester = TelemetryTester()
            tester.send_interval = 0.1  # 0.01
            test_thread = Process(target=tester.run)
            time.sleep(1)
            test_thread.start()

        check_interval = 1
        while True:
            time.sleep(check_interval)
            if Utils.isAllAlive(threads):
                print(f'SOCK-{SOCK_QUEUE1.qsize() + SOCK_QUEUE2.qsize()} DICT-{DICT_QUEUE1.qsize() + DICT_QUEUE2.qsize()} DATA-{DATA_QUEUE.qsize()}')  # TODO ezek is mehetnek a databasebe
            else:
                print("unlucky")
                print(f"sock   {socket_thread.is_alive()}")
                print(f"de1   {decode_thread1.is_alive()}")
                print(f"de2   {decode_thread2.is_alive()}")
                print(f"connection_handler   {connection_handler.is_alive()}")
                break
                # try:
                #     threads = Utils.resetThreads(threads)  # TODO ez szar
                # except ChildProcessError:
                #     break
    finally:
        if Utils.joinAll(threads):
            print("Couldnt stop")
        else:
            print("All stoppped")
