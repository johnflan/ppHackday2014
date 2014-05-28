#!/usr/bin/python
from flask import Flask, request, abort, url_for, redirect
import json
import MySQLdb
import hashlib

app = Flask(__name__)


db = MySQLdb.connect(host="localhost", user="root", passwd="root", db="alaughabet")

@app.route("/")
def hello():
    return "Welcome to Alaughabet"


@app.route("/login", methods = ['POST'])
def login():
    username = request.form['username']
    password = request.form['password']
   
    if (username == "johnflan"):
        passKey = hashlib.sha224(password).hexdigest()
        return redirect(url_for('home', username=username, key=passKey))
    else:
        abort(401)

@app.route("/home", methods = ['GET'])
def home():
    username = request.args.get('username', "none")
    key = request.args.get('key', "none")
    
    if(username != "johnflan"):
        abort(401)
    else:
        print(u"home for user " + username + " key:" + key)
        payload = {"admin": True}    

        return json.dumps(payload);

if __name__ == "__main__":
        app.run(host="0.0.0.0", port=5000, debug=True)
