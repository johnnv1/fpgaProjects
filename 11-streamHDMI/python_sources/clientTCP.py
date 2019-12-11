
import socket
import sys

# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Connect the socket to the port where the server is listening
server_address = ('localhost', 10000)
sock.connect(server_address)

for x in range(20):
    # Send data
    message = b'This is the message.  It will be repeated.'
    print('sending {!r}', message)
    sock.sendall(message)

    # Look for the response
    amount_received = 0
    amount_expected = len(message)
    usleep(1000)
