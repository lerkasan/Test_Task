import socket
import dns.resolver


def get_my_public_ip():
    resolver = dns.resolver.Resolver()
    resolver.nameservers=[socket.gethostbyname('resolver1.opendns.com')]
    public_ip = resolver.query('myip.opendns.com', 'A')[0]
    print("My public IP is", public_ip)
    return public_ip

if __name__ == '__main__':
    get_my_public_ip()
