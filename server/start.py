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
    username = request.form['username']
    password = request.form['password']
   
    if (isValidUser(username)):
        passKey = hashlib.sha224(password).hexdigest()
        return redirect(url_for('home', username=username, key=passKey))
    else:
        abort(401)


@app.route("/home", methods = ['GET'])
def home():
    username = request.args.get('username', "none")
    key = request.args.get('key', "none")

    if(isValidUser(username) == False):
        abort(401)
    else:
        userdetails = getUserDetails(username)
        return Response(json.dumps(userdetails),  mimetype='application/json')

@app.route("/chat/<groupId>", methods = ['GET'])
def getMessages(groupId):

    username = request.args.get('username', 'none')
    if(isValidUser(username) == False):
        abort(401)

    messages = getLastMessages(groupId)
    return Response(json.dumps(messages),  mimetype='application/json')

@app.route("/chat/<groupId>", methods = ['POST'])
def postMessage(groupId):
    username = request.args.get('username', 'none')
    if(username != 'johnflan'):
        abort(401)
    message = request.form['message']
    print(groupId + " " + message + " " + str(int(time.time())))
    return message


@app.route("/chat/<roomId>/<timestamp>", methods = ['GET'])
def getAllMessagesAfter(groupId, timestamp):
    
    username = request.args.get('username', 'none')
    if(username != 'johnflan'):
        abort(401)

    message = {"timestamp": int(time.time() + 200), "username": "CowboyLavin", "message": "just posted a bet", "infoMessage": True}
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


def isValidUser(username):
    query = "select * from users where user_name = '" + username + "'"

    cur = db.cursor() 
    cur.execute(query)

    if(cur.rowcount == 1):
        return True
    else:
        return False

def getUserDetails(username):
    query = "select group_name, groups.group_id, admin from users, group_mappings, groups where users.user_id =" + \
    "group_mappings.user_id and group_mappings.group_id = groups.group_id and " + \
    "users.user_name = '" + username + "';"
    
    cur = db.cursor()
    cur.execute(query)

    print(username + " is a member of " + str(cur.rowcount) + " groups")
    groups = []
    for row in cur.fetchall():
        admin = False
        if (row[2] == 1):
            admin = True
        groupdetails = {"groupName": row[0], "groupId": str(row[1]), "admin": admin}

        userQuery = "select users.user_id, user_name, admin from " +\
        "group_mappings, users where group_id = "+ groupdetails["groupId"] +\
        " and group_mappings.user_id = users.user_id;"

        userCur = db.cursor()
        userCur.execute(userQuery)

        print("The group has " + str(userCur.rowcount) + " members")
        users = []
        for userRow in userCur.fetchall():
            userAdmin = False
            if (userRow[2] == 1):
                userAdmin = True
            user = {"id": str(userRow[0]), "userName": userRow[1], "groupAdmin": userAdmin}
            users.append(user)
        groupdetails["users"] = users
        groups.append(groupdetails)

    userdetails = {}
    userdetails["username"] = username
    userdetails["groups"] = groups

    return userdetails

def getLastMessages(groupid):
    messages = []

    query = "select message_id, users.user_id, user_name, message, info," + \
    "timestamp from chat, users where chat.user_id = users.user_id and group_id" + \
    " = " + groupid + " order by timestamp asc limit 100;"
    cur = db.cursor()
    cur.execute(query)
    
    #(1L, 1L, 'johnflan', 'Ahah ya c*nt.', 0L, 1401303781L)
    #(2L, 10L, 'CowboyLavin', 'Can anyone lend a score.', 0L, 1401303825L)

    
    for row in cur.fetchall():
        print(row)
        statusMessage = False
        if (row[4] == 1):
            statusMessage = True
        message = {"messageId": row[0], "userId": row[1], "userName": row[2],
                "message": row[3], "info": statusMessage, "timestamp": row[5]}
        messages.append(message)
    return messages

if __name__ == "__main__":
        app.run(host="0.0.0.0", port=5000, debug=True)
