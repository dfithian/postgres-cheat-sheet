-- get top 10 biggest tables
select * from svv_table_info order by pct_used desc limit 10;
