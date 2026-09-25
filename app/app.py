from flask import Flask

app = Flask(__name__)


@app.route("/")
def home():
    return "AWS DevOps Project is running!"


@app.route("/health")
def health():
    return "FAILED", 500


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)