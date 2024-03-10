#!/usr/bin/env python3

import os
import sys
import glob
from datetime import datetime

def add_copyright(device, board):
    current_year = datetime.now().year
    str = f"/*\n * Copyright (C) {current_year} The LineageOS Project\n *\n * this file is for attribution only of {device}\n * And public attribution of Xiaomi platforms (like {board} and so)\n */\n"
    for filename in glob.iglob(f'**/{device}*.dtsi', recursive=True):
        with open(filename, 'r+') as file:
            content = file.read()
            file.seek(0, 0)
            file.write(str + '\n' + content)
            file.write(file.read().replace('\t', '    '))
    
if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: addcopyright <device> <board>")
        sys.exit(1)
    device = sys.argv[1]
    board = sys.argv[2]
    add_copyright(device, board)

