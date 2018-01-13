import pymysql
import config

def connection():
    conn = pymysql.connect(host='localhost',
                             user=config.USER,
                             password=config.PASS,
                             db='KlozetDB')
    c = conn.cursor()
    return c, conn

if __name__ == '__main__':
    c, conn = connection()

