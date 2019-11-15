-- see also https://docs.aws.amazon.com/redshift/latest/dg/c_intro_system_views.html

-- get top 10 biggest tables
select * from svv_table_info order by pct_used desc limit 10;
