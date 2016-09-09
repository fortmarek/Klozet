# -*- coding: utf-8 -*-

from geopy.geocoders import GoogleV3
from geopy.exc import GeocoderTimedOut


def get_address_from_coordinates(coordinates):
    geolocator = GoogleV3()

    location = geolocator.reverse(coordinates, timeout=20)

    #Getting only street and house number
    address = location[0][0].encode('utf-8').split(',')[0]
    return address


def replace_space(str):
    decoded_str = str.decode('utf-8')
    i = 0
    for char in decoded_str:
        if char != ' ':
            str_wo_spaces = decoded_str[i:].encode('utf-8')
            return str_wo_spaces
        else:
            i += 1


def get_main_sub_address(adress, coordinates):
    geolocator = GoogleV3()

    places = []

    if adress.find(';') != -1:
        places = adress.split(';')
    else:
        # Normal address and info are mixed into one string, needed to separate
        places = adress.split(',')



    main_address = get_address_from_coordinates(coordinates)
    sub_address = ""

    gen = (place for place in places if place != "" if place != " ")

    for place in gen:
        # Coordinates continue after comma
        if place.find('GPS') != -1:
            return (main_address, sub_address)

        location = geolocator.geocode(place, timeout=20)

        if location == None:

            # Capitalize first word of place
            place = replace_space(place)
            place = place.decode('utf-8')[0].title().encode('utf-8') + place[1:]
            sub_address = place
            print(sub_address)

            return (main_address, sub_address)

    return (main_address, sub_address)
def get_adresses(address, coordinates):

    # Converting to string, needed for geopy reverse function
    str_coordinates = "{0}, {1}".format(coordinates[1], coordinates[0])

    # Getting address and additional info
    (main_address, sub_address) = get_main_sub_address(address, str_coordinates)

    address_dict = {}
    address_dict['main_address'] = main_address
    address_dict['sub_address'] = sub_address

    return address_dict