import os

for i in range(111, 347):

    directory = '/srv/klozet/toilets_img/{0}/'.format(i)

    if not os.path.exists(directory):
        os.mkdir(directory)

    hours_dir = '/srv/klozet/hours_img/{0}/'.format(i)

    if not os.path.exists(hours_dir):
        os.mkdir(hours_dir)
