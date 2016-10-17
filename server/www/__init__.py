from flask import Flask, jsonify, json, url_for, send_from_directory, send_file
from flask_restful import Resource, Api, abort, reqparse
from PIL import Image
from io import BytesIO
import base64
import os

app = Flask(__name__, static_url_path="")
api = Api(app)

class Toilets(Resource):
    def get(self):
        file = open('/home/klozet/wc.json', 'r')
        js = json.loads(file.read())
        file.close()
        return js

api.add_resource(Toilets, '/')

parser = reqparse.RequestParser()
parser.add_argument('encoded_image', type=str)

class ToiletImages(Resource):
    def get(self, klozet_id):
        directory = '/var/www/Klozet/Klozet/static/toilets_img/{0}/'.format(klozet_id)
        images = {'toilet_images':[]}
        image_count = 0
        for file in os.listdir(directory):
            if file.find('.jpg') != -1:
                image_count += 1
                image_file = open(directory + file, 'rb')
                image_data = image_file.read()
                encoded_image_data = image_data.encode('base64')
                images['toilet_images'].append({'image_id': image_count, 'image_data': encoded_image_data})
        return images
    def post(self, klozet_id):
        directory = '/var/www/Klozet/Klozet/static/toilets_img/{0}/'.format(klozet_id)

        image_filename = "0.jpg"

        try:
            file = open(directory + 'log-file.txt', 'r+')
            text = file.read()
            image_index = int(text) + 1
            image_filename = "{0}.jpg".format(image_index)
            file.write("{0}".format(image_index))
            file.close()
            
        except IOError:
            file = open(directory + 'log-file.txt', 'w')
            file.write('0')
            file.close()










        encoded_image = parser.parse_args()['encoded_image']
        decoded_image = Image.open(BytesIO(base64.b64decode(encoded_image)))
        decoded_image.save(directory + image_filename, 'JPEG')
        file = open('/var/www/Klozet/Klozet/static/toilets_img/log-file.txt', 'a')
        file.write("Posted image: {0} for toilet {1}\n".format(image_filename, klozet_id))
        file.close()


api.add_resource(ToiletImages, '/toilet/<string:klozet_id>')
