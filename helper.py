#!/usr/bin/env python3
# helper.py
import os
import subprocess
from colorama import Fore, Style

def repopick(command):
    try:
        subprocess.run(command, check=True)
    except subprocess.CalledProcessError as e:
        die(f"Command '{e.cmd}' returned non-zero exit status {e.returncode}.")

def _adb_connected():
    try:
        subprocess.run(['adb', 'devices'], check=True)
        return True
    except subprocess.CalledProcessError:
        return False

def init_adb_connection():
    if not _adb_connected():
        die("No ADB connection detected. Please connect your device and enable ADB.")

def header(msg):
    print(Fore.CYAN + msg + Style.RESET_ALL)

def die(msg):
    print(Fore.RED + msg + Style.RESET_ALL)
    exit(1)

def success(msg):
    print(Fore.GREEN + msg + Style.RESET_ALL)

def info(msg):
    print(Fore.YELLOW + msg + Style.RESET_ALL)
