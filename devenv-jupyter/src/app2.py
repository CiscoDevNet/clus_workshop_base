from flask import Flask

app2 = Flask(__name__)

@app2.route("/app2")
def hello_world():
    return "<p>Hello, World 2!</p>"

app2.run(host="0.0.0.0", port=5002, debug=False)