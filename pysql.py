#! /usr/bin/env python3

import sys
import psycopg2
import psycopg2.extras
from calendar import Calendar

CONNSTRING = 'dbname=botics application_name=factbook'


def fetch_month_data(year: int, month: int):
    """
    Fetch a month of data from the database.
    """
    date = '%d-%02d-01' % (year, month)
    sql = '''
    select date, shares, trades, dollars
    from factbook where date >= date %s and date < date %s + interval '1month'
    order by date;
    '''
    pgconn = psycopg2.connect(CONNSTRING)
    curs = pgconn.cursor()
    curs.execute(sql, (date, date))

    res = {}
    for (date, shares, trades, dollars) in curs.fetchall():
        res[date] = (shares, trades, dollars)
    return res


def list_book_for_month(year: int, month: int):
    """List all days for a given month and list a factbook for each en
    try for each day.

    Args:
        year
        month
    """
    data = fetch_month_data(year, month)

    cal = Calendar()
    print('%12s | %12s | %12s | %12s' % ('day', 'shares', 'trades', 'dollars'))

    print('%12s-+-%12s-+-%12s-+-%12s' % ('-' * 12, '-' * 12, '-' * 12, '-' * 12))

    for day in cal.itermonthdates(year, month):
        if day.month != month:
            continue
        if day in data:
            shares, trades, dollars = data[day]
        else:
            shares, trades, dollars = 0, 0, 0
        print('%12s | %12s | %12s | %12s' % (day, shares, trades, dollars))


if __name__ == '__main__':
    year = int(sys.argv[1])
    month = int(sys.argv[2])

    list_book_for_month(year, month)