-- indexes
SELECT tablename, indexname, indexdef
  FROM pg_indexes
 WHERE schemaname = 'FIXME'
 ORDER BY tablename, indexname;

-- running queries
SELECT pid, now() - pg_stat_activity.query_start AS duration, query, state
  FROM pg_stat_activity;

-- locks
SELECT t.relname, l.locktype, page, virtualtransaction, pid, mode, granted
  FROM pg_locks l, pg_stat_all_tables t
 WHERE l.relation = t.relid
 ORDER BY relation ASC;

-- db size
SELECT
  pg_database.datname,
  pg_size_pretty(pg_database_size(pg_database.datname)) AS size
  FROM pg_database;

-- table size
SELECT
  schemaname || '.' || relname AS table,
  pg_size_pretty(pg_total_relation_size(relid)) AS size,
  pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) AS external_size
  FROM pg_catalog.pg_statio_user_tables
 WHERE schemaname = 'FIXME';

-- foreign keys
SELECT
  tc.table_schema,
  tc.constraint_name,
  tc.table_name,
  kcu.column_name,
  ccu.table_schema AS foreign_table_schema,
  ccu.table_name AS foreign_table_name,
  ccu.column_name AS foreign_column_name
  FROM
      information_schema.table_constraints AS tc
      JOIN information_schema.key_column_usage AS kcu
          ON tc.constraint_name = kcu.constraint_name
          AND tc.table_schema = kcu.table_schema
      JOIN information_schema.constraint_column_usage AS ccu
          ON ccu.constraint_name = tc.constraint_name
          AND ccu.table_schema = tc.table_schema
 WHERE tc.constraint_type = 'FOREIGN KEY' AND tc.constraint_schema = 'FIXME';

-- nullable fields
select c.table_schema,
       c.table_name,
       c.column_name,
       case c.is_nullable
       when 'NO' then 'not nullable'
       when 'YES' then 'is nullable'
       end as nullable
  from information_schema.columns c
         join information_schema.tables t
             on c.table_schema = t.table_schema
             and c.table_name = t.table_name
 where c.table_schema in ('FIXME')
   and t.table_type = 'BASE TABLE'
   and c.is_nullable = 'YES'
 order by table_schema, table_name, column_name;
