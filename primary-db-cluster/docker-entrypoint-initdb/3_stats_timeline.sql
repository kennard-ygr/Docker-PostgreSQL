\connect grafana

create schema stats_timeline;

alter schema stats_timeline owner to postgres;


create table stats_timeline.tl_stat_activity_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_stat_activity.*
from
    pg_catalog.pg_stat_activity
with no data;

create table stats_timeline.tl_stat_activity (
    like stats_timeline.tl_stat_activity_default
)
partition by range (collected_at);

alter table stats_timeline.tl_stat_activity attach partition stats_timeline.tl_stat_activity_default default;

alter table stats_timeline.tl_stat_activity owner to postgres;

alter table stats_timeline.tl_stat_activity_default owner to postgres;

alter table stats_timeline.tl_stat_activity
    add constraint tl_stat_activity_pkey primary key (collected_at , pid);


create table stats_timeline.tl_stat_replication_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_stat_replication.*
from
    pg_catalog.pg_stat_replication 
with no data;

create table stats_timeline.tl_stat_replication (
    like stats_timeline.tl_stat_replication_default
)
partition by range (collected_at);

alter table stats_timeline.tl_stat_replication attach partition stats_timeline.tl_stat_replication_default default;

alter table stats_timeline.tl_stat_replication owner to postgres;

alter table stats_timeline.tl_stat_replication_default owner to postgres;

alter table stats_timeline.tl_stat_replication
    add constraint tl_stat_replication_pkey primary key (collected_at , pid);


create table stats_timeline.tl_stat_wal_receiver_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_stat_wal_receiver.*
from
    pg_catalog.pg_stat_wal_receiver 
with no data;

create table stats_timeline.tl_stat_wal_receiver (
    like stats_timeline.tl_stat_wal_receiver_default
)
partition by range (collected_at);

alter table stats_timeline.tl_stat_wal_receiver attach partition stats_timeline.tl_stat_wal_receiver_default default;

alter table stats_timeline.tl_stat_wal_receiver owner to postgres;

alter table stats_timeline.tl_stat_wal_receiver_default owner to postgres;

alter table stats_timeline.tl_stat_wal_receiver
    add constraint tl_stat_wal_receiver_pkey primary key (collected_at , pid);


create table stats_timeline.tl_stat_subscription_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_stat_subscription.*
from
    pg_catalog.pg_stat_subscription 
with no data;

create table stats_timeline.tl_stat_subscription (
    like stats_timeline.tl_stat_subscription_default
)
partition by range (collected_at);

alter table stats_timeline.tl_stat_subscription attach partition stats_timeline.tl_stat_subscription_default default;

alter table stats_timeline.tl_stat_subscription owner to postgres;

alter table stats_timeline.tl_stat_subscription_default owner to postgres;

alter table stats_timeline.tl_stat_subscription
    add constraint tl_stat_subscription_pkey primary key (collected_at , subid);


create table stats_timeline.tl_stat_ssl_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_stat_ssl.*
from
    pg_catalog.pg_stat_ssl 
with no data;

create table stats_timeline.tl_stat_ssl (
    like stats_timeline.tl_stat_ssl_default
)
partition by range (collected_at);

alter table stats_timeline.tl_stat_ssl attach partition stats_timeline.tl_stat_ssl_default default;

alter table stats_timeline.tl_stat_ssl owner to postgres;

alter table stats_timeline.tl_stat_ssl_default owner to postgres;

alter table stats_timeline.tl_stat_ssl
    add constraint tl_stat_ssl_pkey primary key (collected_at , pid);


create table stats_timeline.tl_stat_gssapi_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_stat_gssapi.*
from
    pg_catalog.pg_stat_gssapi 
with no data;

create table stats_timeline.tl_stat_gssapi (
    like stats_timeline.tl_stat_gssapi_default
)
partition by range (collected_at);

alter table stats_timeline.tl_stat_gssapi attach partition stats_timeline.tl_stat_gssapi_default default;

alter table stats_timeline.tl_stat_gssapi owner to postgres;

alter table stats_timeline.tl_stat_gssapi_default owner to postgres;

alter table stats_timeline.tl_stat_gssapi
    add constraint tl_stat_gssapi_pkey primary key (collected_at , pid);


create table stats_timeline.tl_stat_archiver_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_stat_archiver.*
from
    pg_catalog.pg_stat_archiver 
with no data;

create table stats_timeline.tl_stat_archiver (
    like stats_timeline.tl_stat_archiver_default
)
partition by range (collected_at);

alter table stats_timeline.tl_stat_archiver attach partition stats_timeline.tl_stat_archiver_default default;

alter table stats_timeline.tl_stat_archiver owner to postgres;

alter table stats_timeline.tl_stat_archiver_default owner to postgres;

alter table stats_timeline.tl_stat_archiver
    add constraint tl_stat_archiver_pkey primary key (collected_at);


create table stats_timeline.tl_stat_bgwriter_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_stat_bgwriter.*
from
    pg_catalog.pg_stat_bgwriter 
with no data;

create table stats_timeline.tl_stat_bgwriter (
    like stats_timeline.tl_stat_bgwriter_default
)
partition by range (collected_at);

alter table stats_timeline.tl_stat_bgwriter attach partition stats_timeline.tl_stat_bgwriter_default default;

alter table stats_timeline.tl_stat_bgwriter owner to postgres;

alter table stats_timeline.tl_stat_bgwriter_default owner to postgres;

alter table stats_timeline.tl_stat_bgwriter
    add constraint tl_stat_bgwriter_pkey primary key (collected_at);


create table stats_timeline.tl_stat_wal_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_stat_wal.*
from
    pg_catalog.pg_stat_wal 
with no data;

create table stats_timeline.tl_stat_wal (
    like stats_timeline.tl_stat_wal_default
)
partition by range (collected_at);

alter table stats_timeline.tl_stat_wal attach partition stats_timeline.tl_stat_wal_default default;

alter table stats_timeline.tl_stat_wal owner to postgres;

alter table stats_timeline.tl_stat_wal_default owner to postgres;

alter table stats_timeline.tl_stat_wal
    add constraint tl_stat_wal_pkey primary key (collected_at);


create table stats_timeline.tl_stat_database_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_stat_database.*
from
    pg_catalog.pg_stat_database 
with no data;

create table stats_timeline.tl_stat_database (
    like stats_timeline.tl_stat_database_default
)
partition by range (collected_at);

alter table stats_timeline.tl_stat_database attach partition stats_timeline.tl_stat_database_default default;

alter table stats_timeline.tl_stat_database owner to postgres;

alter table stats_timeline.tl_stat_database_default owner to postgres;

alter table stats_timeline.tl_stat_database
    add constraint tl_stat_database_pkey primary key (collected_at, datid);


create table stats_timeline.tl_stat_database_conflicts_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_stat_database_conflicts.*
from
    pg_catalog.pg_stat_database_conflicts
with no data;

create table stats_timeline.tl_stat_database_conflicts (
    like stats_timeline.tl_stat_database_conflicts_default
)
partition by range (collected_at);

alter table stats_timeline.tl_stat_database_conflicts attach partition stats_timeline.tl_stat_database_conflicts_default default;

alter table stats_timeline.tl_stat_database_conflicts owner to postgres;

alter table stats_timeline.tl_stat_database_conflicts_default owner to postgres;

alter table stats_timeline.tl_stat_database_conflicts
    add constraint tl_stat_database_conflicts_pkey primary key (collected_at, datid);


create table stats_timeline.tl_stat_all_tables_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_stat_all_tables.*
from
    pg_catalog.pg_stat_all_tables 
with no data;

create table stats_timeline.tl_stat_all_tables (
    like stats_timeline.tl_stat_all_tables_default
)
partition by range (collected_at);

alter table stats_timeline.tl_stat_all_tables attach partition stats_timeline.tl_stat_all_tables_default default;

alter table stats_timeline.tl_stat_all_tables owner to postgres;

alter table stats_timeline.tl_stat_all_tables_default owner to postgres;

alter table stats_timeline.tl_stat_all_tables
    add constraint tl_stat_all_tables_pkey primary key (collected_at, relid);


create table stats_timeline.tl_stat_all_indexes_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_stat_all_indexes.*
from
    pg_catalog.pg_stat_all_indexes 
with no data;

create table stats_timeline.tl_stat_all_indexes (
    like stats_timeline.tl_stat_all_indexes_default
)
partition by range (collected_at);

alter table stats_timeline.tl_stat_all_indexes attach partition stats_timeline.tl_stat_all_indexes_default default;

alter table stats_timeline.tl_stat_all_indexes owner to postgres;

alter table stats_timeline.tl_stat_all_indexes_default owner to postgres;

alter table stats_timeline.tl_stat_all_indexes
    add constraint tl_stat_all_indexes_pkey primary key (collected_at, indexrelid);


create table stats_timeline.tl_statio_all_tables_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_statio_all_tables.*
from
    pg_catalog.pg_statio_all_tables 
with no data;

create table stats_timeline.tl_statio_all_tables (
    like stats_timeline.tl_statio_all_tables_default
)
partition by range (collected_at);

alter table stats_timeline.tl_statio_all_tables attach partition stats_timeline.tl_statio_all_tables_default default;

alter table stats_timeline.tl_statio_all_tables owner to postgres;

alter table stats_timeline.tl_statio_all_tables_default owner to postgres;

alter table stats_timeline.tl_statio_all_tables
    add constraint tl_statio_all_tables_pkey primary key (collected_at, relid);


create table stats_timeline.tl_statio_all_indexes_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_statio_all_indexes.*
from
    pg_catalog.pg_statio_all_indexes 
with no data;

create table stats_timeline.tl_statio_all_indexes (
    like stats_timeline.tl_statio_all_indexes_default
)
partition by range (collected_at);

alter table stats_timeline.tl_statio_all_indexes attach partition stats_timeline.tl_statio_all_indexes_default default;

alter table stats_timeline.tl_statio_all_indexes owner to postgres;

alter table stats_timeline.tl_statio_all_indexes_default owner to postgres;

alter table stats_timeline.tl_statio_all_indexes
    add constraint tl_statio_all_indexes_pkey primary key (collected_at, indexrelid);


create table stats_timeline.tl_statio_all_sequences_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_statio_all_sequences.*
from
    pg_catalog.pg_statio_all_sequences 
with no data;

create table stats_timeline.tl_statio_all_sequences (
    like stats_timeline.tl_statio_all_sequences_default
)
partition by range (collected_at);

alter table stats_timeline.tl_statio_all_sequences attach partition stats_timeline.tl_statio_all_sequences_default default;

alter table stats_timeline.tl_statio_all_sequences owner to postgres;

alter table stats_timeline.tl_statio_all_sequences_default owner to postgres;

alter table stats_timeline.tl_statio_all_sequences
    add constraint tl_statio_all_sequences_pkey primary key (collected_at, relid);


create table stats_timeline.tl_stat_slru_default as
select
    pg_catalog.now() as collected_at
    , pg_catalog.pg_stat_slru.*
from
    pg_catalog.pg_stat_slru 
with no data;

create table stats_timeline.tl_stat_slru (
    like stats_timeline.tl_stat_slru_default
)
partition by range (collected_at);

alter table stats_timeline.tl_stat_slru attach partition stats_timeline.tl_stat_slru_default default;

alter table stats_timeline.tl_stat_slru owner to postgres;

alter table stats_timeline.tl_stat_slru_default owner to postgres;

alter table stats_timeline.tl_stat_slru
    add constraint tl_stat_slru_pkey primary key (collected_at, name);


grant usage on schema stats_timeline to pg_monitor;
grant select on all tables in schema stats_timeline to pg_monitor;
alter default privileges in schema stats_timeline grant select on tables to pg_monitor;