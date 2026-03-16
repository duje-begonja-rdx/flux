import os
import socket

from flask import Flask, request

app = Flask(__name__)

counter = {}

def count_current_route():
    route = request.path
    counter[route] = counter.get(route, 0) + 1

def get_hostname():
    return socket.gethostname()

@app.get("/")
def index():
    count_current_route()
    return "Hello from k3d cluster"


@app.get("/hostname")
def hostname():
    count_current_route()
    return {"hostname": get_hostname()}

@app.get("/counter")
def route_counter():
    result = []
    for route, count in counter.items():
        result.append(f"{route} has been accessed: {count} times.")
    return result

if __name__ == "__main__":
    port = int(os.getenv("FLASK_PORT", "5000"))
    print(f"This is kubernetes pod: {get_hostname()}")
    app.run(host="0.0.0.0", port=port)
