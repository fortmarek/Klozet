# -*- coding: utf-8 -*-
from open_times import get_open_times
from adress import get_adresses
import simplejson as json


def capitalize_price(price):
    # Capitalize first word
    first_word = price.split(' ', 1)[0].title()
    try:
        capitalized_price = first_word + " " + price.split(' ', 1)[1]
        return capitalized_price
    # There is only one word in price
    except IndexError:
        capitalized_price = first_word
        return capitalized_price

dict = {

}

def get_properties(properties_json, coordinates):

    # Object_id
    object_id = properties_json['OBJECTID']
    dict[object_id] = {}

    # Price
    try:
        price = properties_json['CENA'].encode('utf-8')
        capitalized_price = capitalize_price(price)
    # Price is null
    except AttributeError:
        pass

    # Open times
    try:
        open_times = properties_json['OTEVRENO'].encode('utf-8')
        open_times = get_open_times(open_times)
        dict[object_id]['open_times'] = open_times
    # Open_time is null
    except AttributeError:
        pass

    try:
        adress = properties['ADRESA'].encode('utf-8')
        dict[object_id]['address'] = get_adresses(adress, coordinates)
    #Adress is null
    except AttributeError:
        pass

file = open('verejnawc.json', 'r')
js = json.load(file)
data = js['features']
for toilet_json in data:
    properties = toilet_json['properties']
    coordinates = toilet_json['geometry']['coordinates']

    get_properties(properties, coordinates)


js = json.dumps(dict)
file = open('wc.json', 'w+')
file.write(js)
file.close()
