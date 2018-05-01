import os


def application(env, start_response):
    about_file_path = 'static/about.html'
    if not (os.path.exists(about_file_path) and os.path.isfile(about_file_path)):
        not_found(env, start_response)
    start_response('200 OK', [('Content-Type', 'text/html')])
    return [open(about_file_path, "rb").read()]


def not_found(env, start_response):
    start_response('404 Not Found', [('Content-Type', 'text/html')])
    return [b"<html><body>Page not found</body></html>"]
