#!/usr/bin/env python3

import subprocess
import tkinter as tk
from tkinter.scrolledtext import ScrolledText
import time
import os
import argparse
import threading 

class CloseTmuxButtonFrame(tk.Frame):
    def __init__(self, parent, session_name):
        tk.Frame.__init__(self, parent)
        self.session_name = session_name
        if self.session_name:
            self.close_commands =['tmux', 'kill-session', '-t', self.session_name]
        else:
            self.close_commands =['tmux', 'kill-session']
            print("WARNING: I have no session name, i will close a random session!")

        self.submit = tk.Button(self, text="Close Session", height=150, width=150, command = self.send_close)
        self.update_raspberry_ws = tk.Button(self, text="Update FW worspace", command = self.git_remote_update)
        self.update_raspberry_ws.pack()
        self.log = ScrolledText(self, height=10, state=tk.DISABLED)
        self.log.pack()
        self.shutdown_buttons = []
        for i, host in enumerate(["rpi5-ubuntu","rpi5-silver-ubuntu", "raspberrypi"]):
            shutdown_pi = tk.Button(self, text=f"Shutdown {host}", width=150, command = lambda :self.custom_command(host, "sudo shutdown",self.shutdown_buttons, i))
            self.shutdown_buttons.append(shutdown_pi)
            self.shutdown_buttons[i].pack()
        self.submit.pack()

    def log_output(self, text):
        self.log.config(state=tk.NORMAL)
        self.log.insert(tk.END, text+"\n")
        self.log.see(tk.END)
        self.log.config(state=tk.DISABLED)

    def send_close(self):
        print("closing tmux")
        s = os.getenv("WINDOW_TITLE")
        mystring = '\033]2;%s\007'%(s)
        process = subprocess.Popen(self.close_commands,
                     stdout=subprocess.PIPE,
                     stderr=subprocess.PIPE)
        stdout, stderr = process.communicate()
        #subprocess.run(["echo", mystring])
        exit()

    def git_remote_update(self):
#ssh frederico@raspberrypi "cd /home/frederico/github/docker-opensimrt/catkin_devel/src/ros_biomech && git pull && git submodule update --init --recursive"
        self.user= "frederico"
        self.host = "raspberrypi"
        self.command = "cd /home/frederico/github/docker-opensimrt/catkin_devel/src/ros_biomech && git pull && git submodule update --init --recursive"
        def do_update():
            self.update_raspberry_ws.config(state=tk.DISABLED)
            try:
                self.proc = subprocess.Popen(["ssh","-q", "-o","BatchMode=yes","-o","ConnectTimeout=3",f"{self.user}@{self.host}", self.command], stdout= subprocess.PIPE, stderr=subprocess.PIPE)
                stdout, stderr = self.proc.communicate()
                self.after(0, self.log_output, stdout.decode("utf-8") + stderr.decode("utf-8"))
            finally:
                self.after(0, self.update_raspberry_ws.config, {"state": tk.NORMAL})

        threading.Thread(target=do_update,daemon=True).start()
        #print(self.hostreturn)
    def custom_command(self,host, custom_command,button_list, button_i):
#ssh frederico@raspberrypi "cd /home/frederico/github/docker-opensimrt/catkin_devel/src/ros_biomech && git pull && git submodule update --init --recursive"
        self.user= "frederico"
        self.command = custom_command
        button = button_list[button_i]
        def do_update():
            button.config(state=tk.DISABLED)
            try:
                self.proc = subprocess.Popen(["ssh","-q", "-o","BatchMode=yes","-o","ConnectTimeout=3",f"{self.user}@{host}", self.command], stdout= subprocess.PIPE, stderr=subprocess.PIPE)
                stdout, stderr = self.proc.communicate()
                self.after(0, self.log_output, stdout.decode("utf-8") + stderr.decode("utf-8"))
            finally:
                self.after(0, button.config, {"state": tk.NORMAL})

        threading.Thread(target=do_update,daemon=True).start()
        #print(self.hostreturn)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("session", help="tmux session name")
    args = parser.parse_args()
    #session_name = "VIOBackpack"
    root = tk.Tk()
    root.title(args.session)
    root.geometry('200x400+1600+0')
    CloseTmuxButtonFrame(root, args.session).pack(fill="both", expand=True)
    root.mainloop()


