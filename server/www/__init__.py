from flask import Flask, render_template, json, send_from_directory, request
from flask_restful import Resource, Api, abort, reqparse
from templates.dbconnect import connection
import templates.parse as parse
import templates.address as address
from pymysql.converters import escape_item
from PIL import Image
from io import BytesIO
import base64
import getpass

app = Flask(__name__, static_url_path="", static_folder="static")
api = Api(app)

@app.route('/toilets_img/<string:klozet_id>/<string:image_name>')
def toilet_img(klozet_id, image_name):
    directory = '/srv/klozet/toilets_img/{0}/'.format(klozet_id)
    return send_from_directory(directory, image_name)

class Toilets(Resource):
    def get(self, language_version):
        c, conn = connection()
        sql = "SELECT * FROM `toilets`"
        c.execute(sql, ())
        toilets = c.fetchall()

        toilets_dict = {}
        toilets_dict["toilets"] = []

        for toilet in toilets:
            toilet_dict = {}
            toilet_dict["toilet_id"] = toilet[0]
            toilet_dict["price"] = toilet[1]
            toilet_dict["open_times"] = get_open_times(c, toilet[0])
            latitude = float(escape_item(toilet[2], 'utf8'))
            longitude = float(escape_item(toilet[3], 'utf8'))
            toilet_dict["coordinates"] = [latitude, longitude]
            address_dict = {}
            address_dict["main_address"] = toilet[4]
            address_dict["sub_address"] = toilet[5]
            toilet_dict["address"] = address_dict
            toilet_dict["image_count"] = toilet[6]
            toilets_dict["toilets"].append(toilet_dict)

        conn.close()
        return toilets_dict

    def post(self, language_version):
        toilet_dict = request.get_json(self)
        toilet_dict["address"]["main_address"] = address.get_main_address(toilet_dict["coordinates"])
        toilet_dict["open_times"] = [{"hours": [], "days": [1, 2, 3, 4, 5, 6, 7], "nonstop": "True"}]
        parse.toilet_to_db(toilet_dict)



def get_open_times(c, toilet_id):
    sql = "SELECT * FROM `open_times` WHERE `toilet_id` =%s"
    c.execute(sql, toilet_id)
    open_times = c.fetchall()
    open_times_dict_list = []
    for open_time in open_times:
        open_time_dict = {}
        hours = []
        if open_time[2] != None:
            hours.append(open_time[2])
        if open_time[3] != None:
            hours.append(open_time[3])
        open_time_dict["hours"] = hours
        days = ["sun", "mon", "tue", "wed", "thu", "fri", "sat"]
        open_days = []
        for i, is_open in enumerate(open_time[4:10]):
            if is_open == 1 and i == 8:
                open_days.append(2)
            elif is_open == 1:
                open_days.append(i + 1)
        open_time_dict["days"] = open_days
        open_time_dict["nonstop"] = open_time[11] == 1
        open_times_dict_list.append(open_time_dict)
    return open_times_dict_list



api.add_resource(Toilets, '/<string:language_version>')

parser = reqparse.RequestParser()
parser.add_argument('encoded_image', type=str)

class ToiletImages(Resource):
    ''''
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
    '''

    def post(self, klozet_id):

        c, conn = connection()
        image_count_sql = "SELECT `image_count` FROM `toilets` WHERE `toilet_id`=%s"
        c.execute(image_count_sql, klozet_id)
        image_count = c.fetchone()[0]

        sql = "UPDATE `toilets` SET `image_count` = `image_count` + 1 WHERE `toilet_id`=%s"
        c.execute(sql, klozet_id)

        directory = '/srv/klozet/toilets_img/{0}/'.format(klozet_id)

        image_index_str = "{0}".format(image_count)

        encoded_image = parser.parse_args()['encoded_image']
        decoded_image = Image.open(BytesIO(base64.b64decode(encoded_image)))

        decoded_image.save(directory + image_index_str + '.jpg', 'JPEG')

        minimized_image = minimize_image(decoded_image)
        minimized_image.save(directory + image_index_str + '_min.jpg', 'JPEG', optimize=True)


        file = open('/srv/klozet/toilets_img/log-file.txt', 'a')
        file.write("Posted image: {0} for toilet {1}\n".format(image_index_str, klozet_id))
        file.close()

        conn.commit()

def minimize_image(decoded_image):
    width, height = decoded_image.size
    max_size = 120.0
    ratio = min(max_size/width, max_size/height)
    min_size = width * ratio, height * ratio
    decoded_image.thumbnail(min_size)
    return decoded_image

api.add_resource(ToiletImages, '/toilet/<string:klozet_id>')



