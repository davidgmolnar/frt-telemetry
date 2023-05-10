from math import sin
from time import sleep
import serial

ser = serial.Serial('COM9', 468000, timeout=1)
t = 0
while True:
    to_send = []

    to_send.append(0x02)
    to_send.append(0x00)
    to_send.append(10)
    to_send.append(0x02)
    to_send.append(0x84)
    rpm = int(sin(t) * 5000 + 5000)
    print(rpm)
    t += 0.01
    t %= 6.28
    to_send.append(0x00)
    to_send.append(0x00)
    to_send.append(rpm & 0xFF)
    to_send.append((rpm >> 8) & 0xFF)
    for i in range(4):
        to_send.append(0)
    cs = 0
    for byte in to_send:
        cs ^= byte
    to_send.append(cs)
    print(to_send)
    ser.write(to_send)
    sleep(0.01)