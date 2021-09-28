\set start '2017-02-01'

select cast(calendar.entry as date) as date, to_char(coalesce(shares, 0), '99G999G999G999') as shares, to_char(coalesce(trades, 0), '99G999G999') as trades,
to_char(coalesce(dollars, 0), 'L99G999G999G999') as dollars from
/*
* Generate the target's month calendar then LEFT JOIN each day against
* the factbook dataset, so as to have to have every day in the result set,
whether or not there is a book entry for that day.
*/
generate_series(date :'start', date :'start' + interval '1 month' - interval '1 day', interval '1 day')
as calendar(entry) left join factbook on factbook.date = calendar.entry