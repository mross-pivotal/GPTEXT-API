select id,node,ip,ds from json_full join (select
  e.id_ev,
  a.assettag
from
  pdb_eventa_02 e,
  gptext.search(
    TABLE(select * from pdb_eventa_02),
    'demo.public.pdb_eventa_02',
    'NODE\\:efg345',
    null,
    'rows=100'
  ) q,
  assets a
where e.id_ev = q.id
and a.hostname='efg345') x on id = x.id_ev;
