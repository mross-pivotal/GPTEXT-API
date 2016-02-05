insert into pdb_eventa_02 values (11,'{DNS:io.pivotal.com,NODE:efg345,IP:172.16.254.75,DS:Edison NJ,CPU:41,TS:20160122358}');
select * from gptext.index(TABLE(select * from pdb_eventa_02),'demo.public.pdb_eventa_02');
select * from gptext.commit_index('demo.public.pdb_eventa_02');
select parse_and_create();
select * from pdb_eventa_02;
select * from json_full;
