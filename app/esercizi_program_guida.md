### Configurazione dei programmi server e client

Uso:
  mysql [OPTIONS] [database]
```
shell> mysql --verbose --help
shell> mysql --user=root --password=******** mysampledb
shell> mysqldump -u root personnel
shell> mysqlshow --help
```
```
shell> mysql
```
```
shell> mysql --host=localhost --user=root --password=mypwd mysampledb
```

un suffisso  K, M o G a
indica un moltiplicatore di 1.024 con lettere minuscole o maiuscole.

Considera quanto segue
esempio in cui il comando dice al programma mysqladmin di eseguire il ping
server 1.024 volte e sospensione per 10 secondi per ogni ping:
```
shell> mysqladmin --count=1k --sleep=10 ping
```

Ordine di lettura PATH Option File
/etc/my.cnf
/etc/mysql/my.cnf
SYSCONFDIR/my.cnf
$MYSQL_HOME/my.cnf (server program only)
The file specified with --defaults-extra-file, if any
~/.my.cnf for user-specific options
~/.mylogin.cnf for user-specific login path options (client program only)


```
shell> mysql --max_allowed_packet=16M
mysql> SET GLOBAL max_allowed_packet=16*1024*1024;
mysql> show variables like 'max%';
```

Mysql logging

  $ cd
  $ nano .mysql_history
  
  $ sudo nano /var/log/message





Sintassi mysqladmin
```
shell> mysqladmin [options] command [command-arg] [command [command-org]]

Comandi:  
 create db_name 
 debug
 drop db_name 
 password new_password (per una nuova password)
 shutdown
 start-slave
 stop-slave
 status
```

Sintassi mysqlcheck
```
shell> mysqlcheck [options] db_name [tbl_name ...]
shell> mysqlcheck [options] --databases db_name ...
shell> mysqlcheck [options] --all-databases
mysqlcheck --help

{ CHECK TABLE, REPAIR TABLE, ANALYZE TABLE, OPTIMIZE TABLE }
```


Sintassi mysqldump
```
shell> mysqldump [options] db_name [tbl_name ...]
shell> mysqldump [options] --databases db_name ...
shell> mysqldump [options] --all-databases
```

Sintassi mysqlimport
```
shell> mysqlimport [options] db_name textfile1 [textfile2 ...]
mysqlimport --help
```


Sintassi mysqlslap 
  ```
  shell> mysqlslap [options]
```

Creaiamo una simulazione:
Creaiamo una tabella con un unico attributo (int i) e inseriamo il valore 21.
Effettuiamo poi una SELECT con 20 client e ripetiamo il tutto per 100 iterazioni.

```
  mysqlslap --delimiter=";" --create="CREATE TABLE t (i int);INSERT INTO t VALUES (21)" --query="SELECT * FROM t" --concurrency=20 --iterations=100
```

Simulazione creazione attributi(colonne) delle tabelle
```
mysqlslap --concurrency=7 --iterations=20 --number-int-cols=2 --numberchar-cols=2 --auto-generate-sql
```
