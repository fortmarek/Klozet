import simplejson as json


def split_intervals(different_intervals):
    split_interval = different_intervals.split(', ')
    if len(split_interval) > 1:
        return split_interval
    split_interval = different_intervals.split('; ')
    if len(split_interval) > 1:
        return split_interval
    return [different_intervals]
def get_open_times(open_times):
    # for example from monday-thursday the toilets are opened different times than friday-sunday
    diffent_intervals = split_intervals(open_times)
    print(diffent_intervals)


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

def get_properties(properties_json):

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
        get_open_times(open_times)
    # Open_time is set to null
    except AttributeError:
        pass




file = open('verejnawc.json', 'r')
js = json.load(file)
data = js['features']
for toilet_json in data:
    properties = toilet_json['properties']
    get_properties(properties)

