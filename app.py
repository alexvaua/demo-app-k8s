import os
from flask import Flask, request
import redis

app = Flask(__name__)
redis_host = os.environ.get('REDIS_HOST', 'localhost')
redis_port = os.environ.get('REDIS_PORT', 6379)
db = redis.Redis(host=redis_host, port=redis_port)

@app.route('/set/<key>', methods=['POST'])
def set_value(key):
    """set function"""
    value = request.get_data(as_text=True)
    db.set(key, value)
    return f'Set: {key}'

@app.route('/get/<key>', methods=['GET'])
def get_value(key):
    """get function"""
    value = db.get(key)
    if value is not None:
        return value.decode('utf-8')
    else:
        return 'Get Key not found', 404

if __name__ == "__main__":
    app.run(host='0.0.0.0', port=5000)
