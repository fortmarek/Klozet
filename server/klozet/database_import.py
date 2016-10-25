import os

for i in range(1, 248):

    directory = '/srv/klozet/toilets_img/{0}/'.format(i)

    if not os.path.exists(directory):
        os.mkdir(directory)
