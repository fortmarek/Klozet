# -*- coding: utf-8 -*-
from open_times import get_open_times
from address import get_main_address
import simplejson as json
import io
from dbconnect import connection

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
    print(toilet_id)

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
        print("FAILED")
        return

    # Open times
    try:
        open_times = properties_json['OTEVRENO'].encode('utf-8')
        open_times = get_open_times(open_times)
        dict['open_times'] = open_times
    # Open_time is null
    except AttributeError:
        pass

    try:
        adress = properties_json['ADRESA'].encode('utf-8')
        address_dict = {}
        address_dict["main_address"] = get_main_address(coordinates)
        address_dict["sub_address"] = adress
        dict["address"] = address_dict
    #Adress is null
    except AttributeError:
        pass
    return dict

def open_times_to_db(toilet_id, open_times_dict):
    c, conn = connection()
    for open_times in open_times_dict:
        days_dict = get_days_dict(open_times["days"])
        nonstop = is_nonstop(open_times)
        hours = get_hours(open_times)
        sql = "INSERT INTO `open_times` (`toilet_id`, `start_time`, `close_time`, `mon`, `tue`, `wed`, `thu`, `fri`, `sat`, `sun`, `nonstop`) VALUES ((SELECT `toilet_id` FROM `toilets` WHERE `toilet_id` = %s LIMIT 1), %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)"
        c.execute(sql, (toilet_id, hours[0], hours[1], days_dict["mon"], days_dict["tue"], days_dict["wed"], days_dict["thu"], days_dict["fri"], days_dict["sat"], days_dict["sun"], nonstop))
    conn.commit()
    conn.close()

def get_hours(open_times_dict):
        hours = open_times_dict["hours"]
        if len(hours) == 2:
            return hours
        else:
            return [None, None]

def is_nonstop(open_times):
    if open_times["nonstop"] == 'False':
        return 0
    else:
        return 1

def get_days_dict(days_list):
    days_dict = {}
    days_dict["mon"] = includes_day(2, days_list)
    days_dict["tue"] = includes_day(3, days_list)
    days_dict["wed"] = includes_day(4, days_list)
    days_dict["thu"] = includes_day(5, days_list)
    days_dict["fri"] = includes_day(6, days_list)
    days_dict["sat"] = includes_day(7, days_list)
    days_dict["sun"] = includes_day(1, days_list)
    return days_dict

def includes_day(i, open_times):
    if i in open_times:
        return 1
    else:
        return 0

def toilet_to_db(toilet_dict):
    c, conn = connection()
    sql = "SELECT `latitude`, `longitude` FROM `toilets` WHERE `latitude`=%s AND `longitude`=%s"
    coordinates = toilet_dict["coordinates"]
    c.execute(sql, (coordinates[0], coordinates[1]))
    result = c.fetchone()
    if result == None:
        sql = "INSERT INTO `toilets` (`price`, `latitude`, `longitude`, `main_address`, `sub_address`, `image_count`) VALUES (%s, %s, %s, %s, %s, %s)"
        address_dict = toilet_dict["address"]
        c.execute(sql, (toilet_dict["price"], coordinates[0], coordinates[1], address_dict["main_address"], address_dict["sub_address"], 0))
        conn.commit()
        toilet_id = c.lastrowid
        open_times_to_db(toilet_id, toilet_dict["open_times"])
        conn.commit()
        conn.close()
    else:
        conn.close()

def parse():
    file = open('verejnawc.json', 'r')
    js = json.load(file)
    data = js['features']

    toilets = []

    for toilet_json in data:
        properties = toilet_json['properties']
        coordinates = toilet_json['geometry']['coordinates']

        toilets.append(get_properties(properties, coordinates))

    for toilet_dict in toilets:
        print(toilet_dict)
        toilet_to_db(toilet_dict)


    dict = {
        'toilets': toilets
    }
    js = json.dumps(dict, indent=4 * ' ', ensure_ascii=False)
    file = io.open('wc_cs.json', 'w+', encoding='utf-8')
    file.write(js)
    file.close()

if __name__ == '__main__':
    parse()


