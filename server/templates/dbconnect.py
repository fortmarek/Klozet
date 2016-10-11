import pymysql
import config

def connection():
    conn = pymysql.connect(host='localhost',
                             user=config.USER,
                             password=config.PASS,
                             db='KlozetDB',
                             charset='utf8mb4')
    c = conn.cursor()
    sql = "SET NAMES utf8"
    c.execute(sql)
    conn.commit()

    return c, conn
if __name__ == '__main__':
    c, conn = connection()