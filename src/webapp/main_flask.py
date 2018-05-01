import os
import socket
import dns.resolver
from flask import Flask, render_template

application = Flask(__name__)


@application.route("/")
def about_me():
    filename='about.html'
    if not (os.path.exists('static/'+filename) and os.path.isfile('static/'+filename)):
        not_found(FileNotFoundError)
    else:
        return application.send_static_file(filename), 200


def get_public_ip():
    resolver = dns.resolver.Resolver()
    resolver.nameservers=[socket.gethostbyname('resolver1.opendns.com')]
    public_ip = resolver.query('myip.opendns.com', 'A')[0]
    return public_ip


@application.route("/ip")
def show_public_ip():
    public_ip = get_public_ip()
    source = "Flask webapp"
    method = "WSGI"
    filename='public_ip.html'
    if not (os.path.exists('templates/'+filename) and os.path.isfile('static/'+filename)):
        not_found(FileNotFoundError)
    return render_template(filename, public_ip=public_ip, source=source, method=method), 200


@application.errorhandler(404)
def not_found(error):
    return render_template('404.html'), 404


if __name__ == "__main__":
    application.run()
