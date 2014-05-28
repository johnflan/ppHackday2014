#!/usr/bin/python
from flask import Flask, request, abort, url_for, redirect, Response
import json
import MySQLdb
import hashlib
import time

app = Flask(__name__)


db = MySQLdb.connect(host="localhost", user="root", passwd="root", db="alaughabet")

@app.route("/")
def hello():
    return "Welcome to Alaughabet"


@app.route("/login", methods = ['POST'])
def login():
    print(request.args)
    print(request.form)
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
        members = ["Buzz", "TheViper", "Frenchtoast", "TheBoo", "Salmon",
        "Eddie", "Stateside", "BigMick", "CowboyLavin"]
        group = {"admin": True, "name": "Castletown flyboyz", "members":
                members, "groupId": 1}
        groups = [group]
        payload = {"username": username, "groups": groups, "account": ""}
        print(payload)
        return Response(json.dumps(payload),  mimetype='application/json')
        # return json.dumps(payload);


@app.route("/chat/<groupId>", methods = ['GET'])
def getMessages(groupId):

    username = request.args.get('username', 'none')
    if(username != 'johnflan'):
        abort(401)

    message = {"timestamp": int(time.time()), "username": "TheBoo", "message": "Ahah ya c*nt."}
    message1 = {"timestamp": int(time.time() + 200), "username": "CowboyLavin", "message": "Can anyone lend a score."}
    messages = [message, message1]
    return json.dumps(messages)

@app.route("/chat/<groupId>", methods = ['POST'])
def postMessage(groupId):
    
    username = request.args.get('username', 'none')
    if(username != 'johnflan'):
        abort(401)
    
    message = request.data
    #message = request.form['message']
    print(groupId + " " + message + " " + str(int(time.time())))
    return message


@app.route("/chat/<roomId>/<timestamp>", methods = ['GET'])
def getAllMessagesAfter(groupId, timestamp):
    
    username = request.args.get('username', 'none')
    if(username != 'johnflan'):
        abort(401)

    message = {"timestamp": int(time.time() + 200), "username": "CowboyLavin", "message": "Can anyone lend a score."}
    messages = [message]
    return json.dumps(messages)


@app.route("/odds", methods = ['GET'])
def getAllSports():
    sports = ["Football", "Motorsports", "Horseracing"]
    return json.dumps(sports)


@app.route("/odds/<sport>", methods = ["GET"])
def getAllCategories(sport):
    categories = ["WorldCup", "SomeOtherLeague"]
    return json.dumps(categories)


@app.route("/odds/<sport>/<category>", methods = ['GET'])
def getAllOdds(sport, category):
    selections = [{"id": 1, "name": "Brazil v Croatia", "home": "3/10", "draw":"4/1", "away":"10/1"}]
    payload = {"sport": sport, "category": category, "selections": selections}
    return json.dumps(payload)

@app.route("/group/<groupId>/selections", methods = ['GET'])
def getGroupSelections(groupId):
    username = request.args.get('username', 'none')
    if(username != "johnflan"):
        abort(401)

    selection = {"id": 1, "name": "Brazil vs Ireland", "accepted": True}
    selection1 = {"id": 2, "name": "England vs France", "accepted": False}

    payload = [selection, selection1]
    return json.dumps(payload)

@app.route("/group/<groupId>/selections", methods = ['POST'])
def addGroupSelection(groupId):
    username = request.args.get('username', 'none')
    if(username != "johnflan"):
        abort(401)

    payload = {"selectionId": request.data}
    return json.dumps(payload)


if __name__ == "__main__":
        app.run(host="0.0.0.0", port=5000, debug=True)
