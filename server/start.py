#!/usr/bin/python
from flask import Flask, request
import json
import MySQLdb

app = Flask(__name__)


db = MySQLdb.connect(host="localhost", user="root", passwd="root", db="alaughabet")

@app.route("/")
def hello():
    return "Welcome to Alaughabet"


if __name__ == "__main__":
        app.run()
