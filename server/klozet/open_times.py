# -*- coding: utf-8 -*-
from datetime import datetime


def get_open_times(open_times):
    open_times_list = []

    # for example from monday-thursday the toilets are opened different times than friday-sunday
    different_intervals = split_day_intervals(open_times)

    is_nonstop = False
    hours = []
    days = []

    for interval in different_intervals:
        interval_dict = {}
        if interval == 'nonstop':
            is_nonstop = True
        else:
            (is_nonstop, days, hours) = convert_interval(interval)
        interval_dict['nonstop'] = is_nonstop
        interval_dict['days'] = days
        interval_dict['hours'] = hours
        try:
            if len(hours) > 0 or len(days) > 0 or is_nonstop == True:
                open_times_list.append(interval_dict)
        # Hours or days are None, continue
        except TypeError:
            continue
    return open_times_list
def convert_interval(interval):
    interval = interval.replace(' - ', '-')
    split_by_space = interval.split(' ')
    try:
        hours = split_by_space[1]
        hours = get_hours(hours)

        days = split_by_space[0]
        days = get_days(days)

        if days == None and hours != None:
            return (False, [1,2,3,4,5,6,7], hours)

        if hours != None:
            return (False, days, hours)
        else:
            return (False, [], [])
    except IndexError:
        hours = split_by_space[0]
        hours = get_hours(hours)
        return (False, [1,2,3,4,5,6,7], hours)


################ HOURS ################

def convert_hour(hour):
    if hour.find(':') != -1:
        try:
            hour_date = datetime.strptime(hour, '%H:%M')
            return hour_date.strftime("%H:%M")
        # Not supported format
        except ValueError:
            pass
    elif hour.find('.') != -1:
        hour_date = datetime.strptime(hour, '%H.%M')
        return hour_date.strftime("%H:%M")
    else:
        try:
            hour_date = datetime.strptime(hour, '%H')
            return hour_date.strftime("%H:%M")
        # Not supported format
        except ValueError:
            pass



def get_hours(hours):
    individual_hours = hours.split('-')
    try:
        hour_one = fix_hour(individual_hours[0])
        hour_two = fix_hour(individual_hours[1])
        hour_one = convert_hour(hour_one)
        hour_two = convert_hour(hour_two)
        if hour_one != None:
            return [hour_one, hour_two]

    # Not two hours, wrong format
    except IndexError:
        pass

# Replace spaces, change 24 to 00 (datetime can not deal with 24)
def fix_hour(hour):
    hour = hour.replace(' ', '')
    hour = hour.replace('24', '00')
    return hour

######### DAYS #########

days_dict = {
    "ne" : 1,
    "po" : 2,
    "út" : 3,
    "st" : 4,
    "čt" : 5,
    "pá" : 6,
    "so" : 7
}

def split_day_intervals(different_intervals):
    # Two intervals separated by comma
    split_interval = different_intervals.split(', ')
    if len(split_interval) > 1:
        return split_interval

    # Two intervals separated by semicolon
    split_interval = different_intervals.split('; ')
    if len(split_interval) > 1:
        return split_interval

    # Two intervals separated by and
    split_interval = different_intervals.split(' a ')
    if len(split_interval) > 1:
        return split_interval

    # One interval
    return [different_intervals]

def get_day_list(day_one, day_two):
    days_list = []
    if day_one < day_two:
        day = day_one
        while day <= day_two:
            days_list.append(day)
            day += 1
    else:
        day = day_one
        while day <= 7:
            days_list.append(day)
            day += 1
        day = 1
        while day <= day_two:
            days_list.append(day)
            day += 1
    days_list.sort()
    return days_list

def get_days(days):

    # Not an interval, just one day
    try:
        return [days_dict[days]]
    # More days - ie interval
    except KeyError:
        pass

    individual_days = days.split('-')
    try:
        day_one = days_dict[individual_days[0]]
        day_two = days_dict[individual_days[1]]
        days_list = get_day_list(day_one, day_two)
        return days_list
    # Not an interval
    except IndexError:
        pass

    # Day not defined by string
    except KeyError:
        # TODO: support 9:00 -12:00 etc.
        pass