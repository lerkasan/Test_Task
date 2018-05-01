import os


def application(env, start_response):

    # /ip endpoint of localhost is used for FastCGI at Nginx configuration to serve bash script
    routes = [('/', about_me),
              ('/myip', show_public_ip),
              ]

    for path, func in routes:
        if env['PATH_INFO'] == path:
            return func(env, start_response)
    return not_found(env, start_response)


def about_me(env, start_response):
    about_file_path = 'static/about.html'
    if not (os.path.exists(about_file_path) and os.path.isfile(about_file_path)):
        not_found(env, start_response)
    start_response('200 OK', [('Content-Type', 'text/html')])
    return [open(about_file_path, "rb").read()]


def show_public_ip(env, start_response):
    bash_script_path = 'scripts/get_public_ip.sh'
    if not (os.path.exists(bash_script_path) and os.path.isfile(bash_script_path)):
        not_found(env, start_response)
    start_response('200 OK', [('Content-Type', 'text/html')])
    return [os.popen(bash_script_path).read().encode()]


def not_found(env, start_response):
    start_response('404 Not Found', [('Content-Type', 'text/html')])
    return [b"<html><body>Page not found</body></html>"]
