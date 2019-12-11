import socket
import sys

# Create a UDP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

HOST = '10.34.57.31'  # Endereco IP do Servidor
PORT = 5000            # Porta que o Servidor esta

server_address = (HOST, PORT)
message = b'This is the message.  It will be repeated.'
print('vai')
while True:
    # Send data
    print('sending {!r}'.format(message))
    sent = sock.sendto(message, server_address)
    msg = input()

