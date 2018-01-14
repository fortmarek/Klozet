# -*- coding: utf-8 -*-

from geopy.geocoders import GoogleV3

def get_main_address(coordinates):
    # Converting to string, needed for geopy reverse function
    str_coordinates = "{0}, {1}".format(coordinates[1], coordinates[0])

    geolocator = GoogleV3(api_key='AIzaSyBJYKIHOWxhdJRZePgVe6cPUe2TEqRNFIQ')
    location = geolocator.geocode(str_coordinates, timeout=20)
    main_address = location[0].encode('utf-8').split(',')[0]
    return main_address

def get_address(coordinates):

    # Getting address and additional info
    main_address = get_main_address(coordinates)

    address_dict = {}
    address_dict['main_address'] = main_address
    address_dict["sub_address"] = ""

    return address_dict