# -*- coding: utf-8 -*-
from open_times import get_open_times
from adress import get_adresses
import simplejson as json
import io

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

def simplify_price(price):
    simplified_price = price.replace('Jednotná cena ', '')
    return simplified_price

def get_properties(properties_json, coordinates):
    dict = {}
    
    # Object_id
    toilet_id = properties_json['OBJECTID']
    dict['toilet_id'] = toilet_id
    

    # Coordinates
    dict['coordinates'] = coordinates

    # Price
    try:
        price = properties_json['CENA'].encode('utf-8')
        # Capitalize price
        capitalized_price = capitalize_price(price)

        # Getting rid of 'jednotná cena' to make the string simpler (that part is unnecessary)
        simplified_price = simplify_price(capitalized_price)
        dict['price'] = simplified_price
    # Price is null
    except AttributeError:
        pass

    # Open times
    try:
        open_times = properties_json['OTEVRENO'].encode('utf-8')
        open_times = get_open_times(open_times)
        dict['open_times'] = open_times
    # Open_time is null
    except AttributeError:
        pass

    try:
        adress = properties['ADRESA'].encode('utf-8')
        dict['address'] = get_adresses(adress, coordinates)
    #Adress is null
    except AttributeError:
        pass
    return dict

file = open('verejnawc.json', 'r')
js = json.load(file)
data = js['features']

toilets = []

for toilet_json in data:
    properties = toilet_json['properties']
    coordinates = toilet_json['geometry']['coordinates']

    toilets.append(get_properties(properties, coordinates))

dict = {
    'toilets': toilets
    }
js = json.dumps(dict, indent=4 * ' ', ensure_ascii=False)
file = io.open('wc_cs.json', 'w+', encoding='utf-8')
file.write(js)
file.close()

