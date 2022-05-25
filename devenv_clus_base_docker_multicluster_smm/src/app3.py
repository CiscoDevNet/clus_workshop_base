from flask import Flask

app3 = Flask(__name__)

@app3.route("/app3")
def hello_world():
    return "<p>Hello, World 3!</p>"

app3.run(host="0.0.0.0", port=5003, debug=False)