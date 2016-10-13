from flask import Flask, jsonify, json, url_for, send_from_directory, send_file
from flask_restful import Resource, Api, abort, reqparse
import glob

app = Flask(__name__, static_url_path="")
api = Api(app)

class Toilets(Resource):
    def get(self):
        file = open('/home/klozet/wc.json', 'r')
        js = json.loads(file.read())
        file.close()
        #file = url_for('static', filename='toilets_img/5/ToiletPic.png')
        #return send_file('static/toilets_img/5/ToiletPic.png')
        return js

api.add_resource(Toilets, '/')

class ToiletImages(Resource):
    def get(self, klozet_id):
        directory = 'static/toilets_img/{0}'.format(klozet_id)
        return directory

api.add_resource(ToiletImages, '/toilet/<string:klozet_id>')
