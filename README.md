Simple Mod.pm 
```sql
Create database: 
	CREATE DATABASE perl_test;

Create tables: 
	CREATE TABLE telephones
	(
	id int NOT NULL AUTO_INCREMENT,
	name varchar(12),
	phone varchar(11) NOT NULL,
	created timestamp,
	PRIMARY KEY (id)  
	);

Create index:
    CREATE INDEX phone_ind ON telephones (phone);
```
USAGE:
```perl
perl -MMod -MData::Dumper -e '$m = new Mod(connect_str => "dbi:mysql:dbname=perl_test", user => "user", password => "pass"); $m->create_rows(3_000_000); $r1 = $m->get_items(5,100); $r2 = $m->select_by_phone("98422134102"); print Dumper $r1,$r2;'

```
[Other projects here] (https://github.com/ericovva?tab=repositories)
