#!/usr/bin/python

import socket
fd = open("writefile.txt","w")

finalStr = ""
s = socket.socket()
host = socket.gethostname()
port = 123456
s.bind((host,port))
alrdyClose = 0

s.listen(5)
while True:
    c,addr = s.accept()
    fd.write("Connection established from {0}\n".format(addr))
    c.send("Connection established\nPlease enter a ~ to close connection")
    while True:
        ch = c.recv(4)
        if ch == "":
            fd.write("\nConnection CLOSED\n")
            fd.close()
            break
        elif ch == "~":
            c.send("Closing connection, ~ detected")
            c.shutdown(0)
            c.close()
            break
            alrdyClose = 1
        else:
            strSend = "You typed " + ch
            c.send(strSend)
            fd.write(ch)
    if alrdyClose  == 0:
        c.close()
