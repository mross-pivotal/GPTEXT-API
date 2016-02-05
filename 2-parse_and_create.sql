CREATE OR REPLACE FUNCTION parse_and_create ()
  RETURNS VARCHAR(255)
AS $$
  import plpy
  import json

  rows = plpy.execute("select data_ev from pdb_eventa_02 where ingested =  false;")
  ids = plpy.execute("select id_ev from pdb_eventa_02 where ingested =  false;")


  for index,json_data in enumerate(rows):
	  arr = json_data["data_ev"].split(",")
	  json_str = ''

	  for i in arr:
	    split = i.split(":")
	    for data in split:
	      json_str += '"' + data + '":'
              last_index = len(json_str) -1
            json_str = json_str[:last_index] + ','


	  end_cutoff = len(json_str) -3
	  json_str = json_str[:end_cutoff] + '"}'

	  ingest_str = '{"'

          final = ingest_str + json_str[2:]
	  my_json = json.loads(final)
	  cols = plpy.execute("select column_name from information_schema.columns where table_name='json_full'")
	  str = ""
	  columns = []
	  final_values = {}
	  keys_to_index = []
          reload_index = "select * from gptext.reload_index('demo.public.json_full');"
          populate_index = "select * from gptext.index(TABLE(select * from json_full),'demo.public.json_full');"
          commit_index = "select * from gptext.commit_index('demo.public.json_full');"
	  count = 0
	  for entry in cols:
	    for k,v in entry.iteritems():
	      columns.append(v.lower())

	  statement = "alter table json_full "

	  for key, value in my_json.iteritems():
	    key= key.lower()
	    value = value.lower()
	    if isinstance(value, dict):
	      for sub_key, sub_value in my_json[key].iteritems():

		named_key = key + "_" + sub_key

		if named_key.lower() not in columns:
		  statement += " ADD " + named_key.lower() + " VARCHAR(255), "
		  keys_to_index.append(named_key)
		  columns.append(named_key.lower())
	    if key.lower() not in columns:
	      statement += " ADD " + key.lower() + " VARCHAR(255), "
	      keys_to_index.append(key)
	    final_values[key] = value
	  if statement != "alter table json_full ":
		cutoff = len(statement) - 2
		statement = statement[:cutoff]
		statement += ";"
		rv = plpy.execute(statement, 5)
	  columns_string = "("
          values_string = "("
          for col, entry in final_values.iteritems():
            columns_string += col + ", "
            stringify = unicode(entry).encode('utf-8')
            values_string +=  "'" + stringify + "'" + ", "

          columns_string += "id)"
          id = stringify = unicode(ids[index]["id_ev"]).encode('utf-8')
	  values_string += id + ")"


          insert_statement = "INSERT INTO json_full "  + columns_string + " VALUES " + values_string + ";"
          rv = plpy.execute(insert_statement, 5)
          update_statement = "UPDATE pdb_eventa_02 SET ingested = true WHERE id_ev = " + id + ";"
	  rv = plpy.execute(update_statement, 5)

  return statement + " " + insert_statement
$$ LANGUAGE plpythonu;

select parse_and_create();
select * from pdb_eventa_02;
select * from json_full;
