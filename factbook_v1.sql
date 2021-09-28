begin;

create table factbook
(
    year int,
    date date,
    shares text,
    trades text,
    dollars text
);

\copy factbook from 'TAOP/data/factbook/factbook.csv' with delimiter E'\t' null ''

alter table factbook
    alter shares
        type bigint
    using replace(shares, ',', '')::bigint,

    alter trades
        type bigint
    using replace(trades, ',', '')::bigint,

    alter dollars
        type bigint
    using substring(replace(dollars, ',', '') from 2)::numeric;

commit;

select pgc.conname as constraint_name,
       ccu.table_schema as table_schema,
       ccu.table_name,
       ccu.column_name,
       pgc.consrc as definition
from pg_constraint pgc join pg_namespace nsp on nsp.oid = pgc.connamespace join pg_class  cls on pgc.conrelid = cls.oid left join information_schema.constraint_column_usage ccu on pgc.conname = ccu.constraint_name
          and nsp.nspname = ccu.constraint_schema where contype ='c' order by pgc.conname;