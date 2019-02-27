#!/usr/bin/env python3.6

from PJONdaemonlib import PJONdaemon
from PJONdaemonlib.utils import printerr
from tempfile import gettempdir
import sys

if __name__ == '__main__':

    try:
        cmd = sys.argv[1]
    except:
        printerr(f'{argv[1]} CMD', 'CMD: start, stop, restart or status')
    com = PJONdaemon(pid_dir=gettempdir()) 

    def start():
        com.setup('/dev/escaperoom', 9600, 0x42) #TODO config file
        com.start()

    def stop():
        if not com.stop(block=True):
            printerr('Failed to stop')

    if cmd == 'start':
        start()
    elif cmd == 'restart':
        if com.is_running():
            stop()
        start()
    elif cmd == 'stop':
        stop()
    elif cmd == 'status':
        print('running' if com.is_running() else 'stopped')
    elif cmd == 'socket':
        if not com.is_running():
            printerr('PJON-daemon is not running')
        else:
            print(com.socket_path)

