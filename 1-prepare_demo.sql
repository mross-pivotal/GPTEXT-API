drop table pdb_eventa_02;
drop table json_full;
create table json_full (id VARCHAR(255));
create table pdb_eventa_02(id_ev bigint, data_ev text, ingested boolean DEFAULT FALSE) distributed by (id_ev);
select * from gptext.drop_index('public','pdb_eventa_02');
insert into pdb_eventa_02 values (1,'{NODE:abc123,IP:172.16.253.28,DS:Charlotte NC,CPU:21,TS:20160126134207}');
insert into pdb_eventa_02 values (2,'{NODE:abc124,IP:172.16.253.29,DS:Charlotte NC,CPU:91,TS:20160126134207}');
insert into pdb_eventa_02 values (3,'{NODE:efg345,IP:172.16.254.75,DS:Edison NJ,CPU:1,TS:20160126134207}'); 

select * from gptext.create_index('public','pdb_eventa_02','id_ev','data_ev');
select * from gptext.index(TABLE(select * from pdb_eventa_02),'demo.public.pdb_eventa_02');
select * from gptext.commit_index('demo.public.pdb_eventa_02');

select * from pdb_eventa_02;
select * from json_staging;

