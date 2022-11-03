import time
import TelemetryHandler as Handler
from multiprocessing import Process


def reMap(remap, key, value):
    try:
        defaults = remap[key]
        key = defaults['new_name']
        if defaults['default_bool'] is not None:
            if value == 0:
                return key, 1
            elif value == 1:
                return key, 0
            else:
                print("nemboolt hogy akarsz invertálni te buzi")
        elif defaults['default_num'] is not None:
            return key, value * defaults['default_num']
        else:
            return key, value
    except KeyError:
        print("Did not find key: " + key + " reformat needed")
        return reformatString(key), value


def reformatString(signal_name):  # TODO
    if signal_name.isupper():
        return signal_name
    formatted_name_vec = signal_name.split("_")
    for index, part in enumerate(formatted_name_vec):
        if len(part) < 1:
            return ""
        end = part[1: len(part)]
        newstart = part[0].upper()
        formatted_name_vec[index] = newstart + end
    return "".join(formatted_name_vec)


def reformatInit(remap_setup, can1, can2, multiplexed):
    remap_override = list(zip(*remap_setup))

    trigger = []
    for message in can1.messages:
        if message.frame_id not in multiplexed:
            trigger.extend(message.signal_tree)
    for message in can2.messages:
        if message.frame_id not in multiplexed:
            trigger.extend(message.signal_tree)

    new_names = []
    for signalname in trigger:
        new_names.append(reformatString(signalname))

    default_bool = []
    default_num = []
    for i in trigger:
        default_bool.append(None)
        default_num.append(None)

    for override_index, signal_to_override in enumerate(remap_override[0]):
        if signal_to_override in trigger:
            index = trigger.index(signal_to_override)
            new_names[index] = remap_override[1][override_index]
            default_bool[index] = remap_override[2][override_index]
            default_num[index] = remap_override[3][override_index]
        else:
            print("hmmmmmmmmmmmmmmmmmm")
            print(signal_to_override)

    # TODO ez oké hogy csak init de azért még elég kókány
    dict_map = dict()
    keys = ["new_name", "default_bool", "default_num"]
    temp = dict.fromkeys(keys)
    for i, entry in enumerate(trigger):
        temp['new_name'] = new_names[i]
        temp['default_bool'] = default_bool[i]
        temp['default_num'] = default_num[i]
        dict_map[entry] = dict(temp)  # copy
    return dict_map


def isAllAlive(thread_list):
    for thread in thread_list:
        if not thread.is_alive():
            return False
    return True


def isAnyAlive(thread_list):
    for thread in thread_list:
        if thread.is_alive():
            return True
    return False


def resetThreads(thread_list):
    if joinAll(thread_list):
        raise ChildProcessError
    return initThreads()


def joinAll(thread_list):
    join_attempt_limit = 10
    join_attempt = 0
    while isAnyAlive(thread_list) and join_attempt < join_attempt_limit:
        for thread in thread_list:
            if thread.is_alive():
                thread.join(0.1)
        join_attempt += 1

    if join_attempt >= 10:
        for thread in thread_list:
            if thread.is_alive():
                thread.kill()
        time.sleep(0.5)

    return isAnyAlive(thread_list)


def initThreads():
    socket_thread = Process(target=Handler.readSock, args=(Handler.STOP_QUEUE, Handler.SOCK_QUEUE1, Handler.SOCK_QUEUE2))
    decode_thread1 = Process(target=Handler.decodeCan, args=(Handler.CAN1, Handler.MULTIPLEXED_SIGNALS, Handler.STOP_QUEUE, Handler.SOCK_QUEUE1, Handler.DICT_QUEUE1))
    decode_thread2 = Process(target=Handler.decodeCan, args=(Handler.CAN1, Handler.MULTIPLEXED_SIGNALS, Handler.STOP_QUEUE, Handler.SOCK_QUEUE2, Handler.DICT_QUEUE2))
    reformat_thread1 = Process(target=Handler.reformat, args=(Handler.REMAP_SETUP, Handler.CAN1, Handler.CAN2, Handler.MULTIPLEXED_SIGNALS, Handler.STOP_QUEUE, Handler.DICT_QUEUE1, Handler.DATA_QUEUE))
    reformat_thread2 = Process(target=Handler.reformat, args=(Handler.REMAP_SETUP, Handler.CAN1, Handler.CAN2, Handler.MULTIPLEXED_SIGNALS, Handler.STOP_QUEUE, Handler.DICT_QUEUE1, Handler.DATA_QUEUE))
    upload_thread = Process(target=Handler.upload, args=(Handler.TOKEN, Handler.ORG, Handler.BUCKET, Handler.STOP_QUEUE, Handler.DATA_QUEUE))

    socket_thread.start()
    decode_thread1.start()
    decode_thread2.start()
    reformat_thread1.start()
    reformat_thread2.start()
    upload_thread.start()

    threads = [socket_thread,
               decode_thread1,
               decode_thread2,
               reformat_thread1,
               reformat_thread2,
               upload_thread]

    return threads
