select idmsg, message
from
  messagelog e,
  gptext.search(
    TABLE(select * from messagelog),
    'demo.public.messagelog',
    'vlan',
    null,
    'rows=100'
  ) q where e.idmsg = q.id ;
