from flask import Flask, jsonify, json
from flask_restful import Resource, Api, abort, reqparse
#from templates.dbconnect import connection

app = Flask(__name__)
api = Api(app)

class Toilets(Resource):
    def get(self):
        file = open('/home/klozet/wc.json', 'r')
        js = json.loads(file.read())
        file.close()
        return js
api.add_resource(Toilets, '/')

