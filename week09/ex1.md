Function to retrieve addresses that contains “11” and city_id between 400-600
```
CREATE OR REPLACE FUNCTION retrieve()
RETURNS TABLE(address VARCHAR(50), city_id INTEGER)
LANGUAGE SQL
AS $$
  SELECT address, city_id 
  FROM address 
  WHERE address LIKE '%11%' AND 
        city_id >= 400 AND 
        city_id <= 600
$$;
```

Call the function from Python script and use geoPy to generate longitude and latitude and Create Query to update Address table with new values
```
# create db
# psql -d template1
import psycopg2
from geopy.geocoders import Nominatim
# https://stackabuse.com/working-with-postgresql-in-python/
con = psycopg2.connect(database="dvdrental", user="postgres",
                       password="1111", host="127.0.0.1", port="5432")

print("Database opened successfully")

cur = con.cursor()
# call function
retrieve_query = "SELECT * FROM retrieve();"
cur.execute(retrieve_query)
rows = cur.fetchall()
print("function call result:", rows)

# add longitude and latitude columns
add_culumns_query = "ALTER TABLE address ADD COLUMN longitude real default 0, ADD COLUMN latitude real default 0;"
cur.execute(add_culumns_query)
con.commit()

# add longitude and latitude to rows
address_ids_query = "SELECT address_id, address FROM address"
cur.execute(address_ids_query)
address_ids = cur.fetchall()
geolocator = Nominatim(user_agent="specify_your_app_name_hereasdad")
for address_id, address in address_ids:
    location = geolocator.geocode(address, timeout=10)
    latitude = location.latitude if location else 0
    longitude = location.longitude if location else 0
    insert_ll_query = f"UPDATE address SET longitude = {longitude}, latitude = {latitude} WHERE address_id = " \
                      f"{address_id};"
    cur.execute(insert_ll_query)
    con.commit()

    row_query = f"SELECT * FROM address WHERE address_id = {address_id};"
    cur.execute(row_query)
    row = cur.fetchall()
    print("updated row:", row)

con.close()
```

Output of the Python script (in addition to screenshot)
```
Database opened successfully
function call result: [('1411 Lillydale Drive', 576), ('117 Boa Vista Way', 566), ('1103 Bilbays Parkway', 578), ('1192 Tongliao Street', 470), ('1145 Vilnius Manor', 451), ('114 Jalib al-Shuyukh Manor', 585), ('1191 Tandil Drive', 523), ('1133 Rizhao Avenue', 572), ('1197 Sokoto Boulevard', 478), ('1152 al-Qatif Lane', 412), ('1176 Southend-on-Sea Manor', 458), ('1101 Bucuresti Boulevard', 401), ('1103 Quilmes Boulevard', 503), ('1121 Loja Avenue', 449)]
updated row: [(4, '1411 Lillydale Drive', None, 'QLD', 576, '', '6172235589', datetime.datetime(2022, 4, 15, 21, 12, 44, 609521), -82.40084, 36.125748)]
updated row: [(5, '1913 Hanoi Way', '', 'Nagasaki', 463, '35200', '28303384290', datetime.datetime(2022, 4, 15, 21, 12, 45, 892630), 115.82539, -31.775618)]
updated row: [(7, '692 Joliet Street', '', 'Attika', 38, '83579', '448477190408', datetime.datetime(2022, 4, 15, 21, 12, 46, 163773), -116.68094, 43.675453)]
updated row: [(8, '1566 Inegl Manor', '', 'Mandalay', 349, '53561', '705814003527', datetime.datetime(2022, 4, 15, 21, 12, 46, 790895), 0.0, 0.0)]
updated row: [(9, '53 Idfu Parkway', '', 'Nantou', 361, '42399', '10655648674', datetime.datetime(2022, 4, 15, 21, 12, 47, 138680), 0.0, 0.0)]
updated row: [(10, '1795 Santiago de Compostela Way', '', 'Texas', 295, '18743', '860452626434', datetime.datetime(2022, 4, 15, 21, 12, 47, 812605), -8.555915, 42.86398)]
updated row: [(11, '900 Santiago de Compostela Parkway', '', 'Central Serbia', 280, '93896', '716571220373', datetime.datetime(2022, 4, 15, 21, 12, 48, 427048), 0.0, 0.0)]
updated row: [(12, '478 Joliet Way', '', 'Hamilton', 200, '77948', '657282285970', datetime.datetime(2022, 4, 15, 21, 12, 48, 997665), -105.25492, 39.96841)]
updated row: [(13, '613 Korolev Drive', '', 'Masqat', 329, '45844', '380657522649', datetime.datetime(2022, 4, 15, 21, 12, 49, 246560), 0.0, 0.0)]
updated row: [(15, '1542 Tarlac Parkway', '', 'Kanagawa', 440, '1027', '635297277345', datetime.datetime(2022, 4, 15, 21, 12, 50, 679057), 0.0, 0.0)]
updated row: [(16, '808 Bhopal Manor', '', 'Haryana', 582, '10672', '465887807014', datetime.datetime(2022, 4, 15, 21, 12, 51, 1542), 0.0, 0.0)]
...
```
