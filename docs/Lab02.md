 # Lab02 Hands-On MySQL 8.0


```
mysql> SHOW TABLES;
+---------------------+
| Tables in menagerie |
+---------------------+
| pet                 |
+---------------------+
```

```
mysql> SHOW CREATE TABLES pet;

```

```
mysql> DESCRIBE pet;
+---------+-------------+------+-----+---------+-------+
| Field   | Type        | Null | Key | Default | Extra |
+---------+-------------+------+-----+---------+-------+
| name    | varchar(20) | YES  |     | NULL    |       |
| owner   | varchar(20) | YES  |     | NULL    |       |
| species | varchar(20) | YES  |     | NULL    |       |
| sex     | char(1)     | YES  |     | NULL    |       |
| birth   | date        | YES  |     | NULL    |       |
| death   | date        | YES  |     | NULL    |       |
+---------+-------------+------+-----+---------+-------+
```

Popoliamo un pò il database con dei valori a vostra scelta
```
mysql> INSERT INTO pet
       VALUES ('Puffball','Diane','hamster','f','1999-03-30',NULL);
       +----------+-------+---------+------+------------+-------+
| name     | owner | species | sex  | birth      | death |
+----------+-------+---------+------+------------+-------+
| Chirpy   | Gwen  | bird    | f    | 1998-09-11 | NULL  |
| Whistler | Gwen  | bird    | NULL | 1997-12-09 | NULL  |
| Slim     | Benny | snake   | m    | 1996-04-29 | NULL  |
+----------+-------+---------+------+------------+-------+
```


```
mysql> SELECT * FROM pet;

```


```
mysql> DELETE FROM pet where name LIKE 'Slim';
```

Al posto di Bower usare un nome presente nella propria base di dati
```
mysql> UPDATE pet SET birth = '1989-08-31' WHERE name = 'Bowser'; 
```


```
mysql> SELECT * FROM pet WHERE name = 'Bowser';
```


```
mysql> SELECT * FROM pet WHERE birth >= '1998-1-1';
```




```
mysql> SELECT name, birth FROM pet ORDER BY birth DESC;

```


```
mysql> SELECT * FROM pet WHERE species = 'dog' AND sex = 'f';
```


```
mysql> SELECT * FROM pet WHERE species = 'snake' OR species = 'bird';
```


```
mysql> SELECT * FROM pet WHERE (species = 'cat' AND sex = 'm')
       OR (species = 'dog' AND sex = 'f');
```


```
mysql> SELECT name, birth FROM pet;

```

DISTICT è il comando che serve per ottenere un singolo risultato in caso di duplicati (per quel valore) nella tabella
```
mysql> SELECT DISTINCT owner FROM pet;

```

```
mysql> SELECT name, birth, CURDATE(),
       TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age
       FROM pet;
```


```
mysql> SELECT name, birth, CURDATE(),
       TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age
       FROM pet ORDER BY name;
```

Quanti anni ha il pet
```
mysql> SELECT name, birth, CURDATE(),
       TIMESTAMPDIFF(YEAR,birth,CURDATE()) AS age
       FROM pet ORDER BY age;
```

Determinare l'età dei pet che sono morti, non di quelli in vita
La query utilizza death IS NOT NULL anziché death <> NULL perché NULL è un valore speciale che non può essere confrontato utilizzando i soliti operatori di confronto.
```
mysql> SELECT name, birth, death,
       TIMESTAMPDIFF(YEAR,birth,death) AS age
       FROM pet WHERE death IS NOT NULL ORDER BY age;
```


```
mysql> SELECT name, birth, MONTH(birth) FROM pet;
```


```
mysql> SELECT name, birth FROM pet WHERE MONTH(birth) = 5;
```


```
mysql> SELECT name, birth FROM pet
       WHERE MONTH(birth) = MONTH(DATE_ADD(CURDATE(),INTERVAL 1 MONTH));
```


```
mysql> SELECT name, birth FROM pet
       WHERE MONTH(birth) = MOD(MONTH(CURDATE()), 12) + 1;
```


```
mysql> SELECT '2018-10-31' + INTERVAL 1 DAY;
```

Per verificare NULL, utilizzare gli operatori IS NULLe IS NOT NULL
```
mysql> SELECT 1 IS NULL, 1 IS NOT NULL;
```

Non è possibile utilizzare gli operatori di confronto aritmetici quali =, < o <> per verificare NULL
```
mysql> SELECT 1 = NULL, 1 <> NULL, 1 < NULL, 1 > NULL;
```

Un errore comune quando si lavora con NULLè supporre che non sia possibile inserire uno zero o una stringa vuota in una colonna definita come NOT NULL, ma non è così. Questi sono in realtà valori, mentre NULLsignifica " non avere un valore
```
mysql> SELECT 0 IS NULL, 0 IS NOT NULL, '' IS NULL, '' IS NOT NULL;
```

Che terminano con 'fy'
```
mysql> SELECT * FROM pet WHERE name LIKE '%fy';
```

Nomi che iniziano con b
```
mysql> SELECT * FROM pet WHERE name LIKE 'b%';
```

Contenenti 'w'
```
mysql> SELECT * FROM pet WHERE name LIKE '%w%';
```

Nomi composti da 5 caratteri
```
mysql> SELECT * FROM pet WHERE name LIKE '_____';
```

Se volete usare le Espressioni Regolari
Nomi composti da b minuscola all'inizio del nome
```
mysql> SELECT * FROM pet WHERE REGEXP_LIKE(name, '^b');
```


```
mysql> SELECT COUNT(*) FROM pet;
```

Quanti animali hanno le persone a testa
```
mysql> SELECT owner, COUNT(*) FROM pet GROUP BY owner;
```

Numero di animali per specie:
```
mysql> SELECT species, COUNT(*) FROM pet GROUP BY species;
```

Numero di animali per combinazione di specie e sesso:
```
mysql> SELECT sex, COUNT(*) FROM pet GROUP BY sex;
```

Non è necessario recuperare un'intera tabella quando si utilizza COUNT()
```
mysql> SELECT species, sex, COUNT(*) FROM pet GROUP BY species, sex;
```


```
mysql> SELECT species, sex, COUNT(*) FROM pet
       WHERE sex IS NOT NULL
       GROUP BY species, sex;
```



Per iniziare con un AUTO_INCREMENTvalore diverso da 1, impostare quel valore con CREATE TABLE o ALTER TABLE, 
```
mysql> ALTER TABLE tbl AUTO_INCREMENT = 100;
```
***

Il server MySQL ha alcune opzioni di comando che possono essere specificate solo all'avvio e una serie di variabili di sistema, alcune delle quali possono essere impostate all'avvio, in fase di esecuzione o in entrambi.
Set variabile di sistema general_log (abilita i
```
SET GLOBAL general_log = ON;
SELECT @@GLOBAL.general_log;
```


Passiamo le istruzioni SQL da linea di comando
```
shell> mysql -u root -p -e "SELECT VERSION();SELECT NOW()"
```

## mysql_config_editor
shell> mysql_config_editor set --login-path=mysql
         --host=localhost --user=studente --password
```
shell> mysql_config_editor print --all
[mysql]
user = studente
password = *****
host = localhost

```
Controlliamo nella home

```
$ cd 
$ nano .mylogin.cnf
```


```
$ mysql

```



```
shell> mysql_config_editor remove --login-path=mysql 
```


```
shell> mysql_config_editor print --all
```

***

### Guida e esercizi MySQL Programs

Uso:
  mysql [OPTIONS] [database]
```
shell> mysql --verbose --help
shell> mysql --user=root --password=******** mysampledb
shell> mysqldump -u root personnel
shell> mysqlshow --help
shell> mysqld_safe --verbose --help
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




***

## mysqlbinlog
```
$ cd /var/lib/mysql

```


```
shell> mysqlbinlog binlog.0000003
```
>Nella prima riga, il numero che segue at indica l'offset del file o la posizione iniziale dell'evento nel file di registro binario.
>
>La seconda riga inizia con una data e un'ora che indicano quando è iniziata l'istruzione sul server in cui ha avuto origine l'evento. 
>Per la replica, timestamp viene propagato ai server slave. server id è il server_id, id del server in cui ha avuto origine l'evento. 
>end_log_pos indica dove inizia l'evento successivo (ovvero, è la posizione finale dell'evento corrente + 1). 
>thread_id indica quale thread ha eseguito l'evento. 
>exec_time è il tempo impiegato per eseguire l'evento, su un server master. Su uno slave, è la differenza del tempo di esecuzione finale sullo slave meno il tempo di esecuzione iniziale sul master. 
>La differenza funge da indicatore di quanto la replica è in ritardo rispetto al master. 
>error_code indica il risultato dell'esecuzione dell'evento. Zero indica che non si è verificato alcun errore.


L'output di mysqlbinlog può essere rieseguito (ad esempio, utilizzandolo come input per mysql ) per ripetere le istruzioni nel registro

```

```

Richiede il BINLOG privilegio
```
PURGE BINARY LOGS TO 'mysql-bin.010';
PURGE BINARY LOGS BEFORE '2020-070-8 18:42:03';
```

*** 
Utenti e ruoli

```
SHOW GRANTS FOR 'studente'@'localhost';
```


```
SHOW CREATE USER 'studente'@'localhost';
```

Modificare ad hoc
```
CREATE USER 'david'@'198.51.100.0/255.255.255.0';
```
>Una maschera di rete in genere inizia con bit impostati su 1, seguiti da bit impostati su 0. Esempi:

>198.0.0.0/255.0.0.0: Qualsiasi host sulla rete di classe A 198

>198.51.100.0/255.255.0.0: Qualsiasi host sulla rete di classe B 198.51

>198.51.100.0/255.255.255.0: Qualsiasi host sulla rete di classe C 198.51.100

>198.51.100.1: Solo l'host con questo indirizzo IP specifico


I nomi dei ruoli MySQL si riferiscono ai ruoli, che sono denominati raccolte di privilegi
```
SET ROLE 'myrole'@'%';
```


```
CREATE USER 'finley'@'localhost'
  IDENTIFIED BY 'password';
```


```
GRANT ALL
  ON *.*
  TO 'finley'@'localhost'
  WITH GRANT OPTION;
```


```
CREATE USER 'admin'@'localhost'
  IDENTIFIED BY 'password';
GRANT RELOAD,PROCESS
  ON *.*
  TO 'admin'@'localhost';
```


```
CREATE USER 'custom'@'localhost'
  IDENTIFIED BY 'password';
GRANT ALL
  ON bankaccount.*
  TO 'custom'@'localhost';
```


```
CREATE USER 'custom'@'host47.example.com'
  IDENTIFIED BY 'password';
GRANT SELECT,INSERT,UPDATE,DELETE,CREATE,DROP
  ON expenses.*
  TO 'custom'@'host47.example.com';
```


```
REVOKE ALL
  ON *.*
  FROM 'finley'@'%.example.com';

REVOKE RELOAD
  ON *.*
  FROM 'admin'@'localhost';
```


```
REVOKE CREATE,DROP
  ON expenses.*
  FROM 'custom'@'host47.example.com';
```


```
REVOKE INSERT,UPDATE,DELETE
  ON customer.addresses
  FROM 'custom'@'%.example.com';
```


```
DROP USER 'finley'@'localhost';
```




```
CREATE ROLE 'app_developer', 'app_read', 'app_write';
```


```
GRANT ALL ON app_db.* TO 'app_developer';
```
```
GRANT SELECT ON app_db.* TO 'app_read';
```
```
GRANT INSERT, UPDATE, DELETE ON app_db.* TO 'app_write';
```


```
CREATE USER 'dev1'@'localhost' IDENTIFIED BY 'dev1pass';

```


```
CREATE USER 'read_user1'@'localhost' IDENTIFIED BY 'read_user1pass';
```


```
CREATE USER 'read_user2'@'localhost' IDENTIFIED BY 'read_user2pass';
```


```
CREATE USER 'rw_user1'@'localhost' IDENTIFIED BY 'rw_user1pass';
```


```
GRANT 'app_developer' TO 'dev1'@'localhost';
```


```
GRANT 'app_read' TO 'read_user1'@'localhost', 'read_user2'@'localhost';
```


```
GRANT 'app_read', 'app_write' TO 'rw_user1'@'localhost';
```
Per impostare nel my.cnf i ruoli obbligatori all'avvio del server
```
[mysqld]
mandatory_roles='role1,role2@localhost,r3@%.example.com'
```
uguale a ( a runtime )
```
SET PERSIST mandatory_roles = 'role1,role2@localhost,r3@%.example.com';
```
Verifichiamo i ruoli
```
mysql> SHOW GRANTS FOR 'dev1'@'localhost';
```

```
mysql> SHOW GRANTS FOR 'dev1'@'localhost' USING 'app_developer';
```


```
mysql> SELECT CURRENT_ROLE();
```

```
SET DEFAULT ROLE ALL TO
  'dev1'@'localhost',
  'read_user1'@'localhost',
  'read_user2'@'localhost',
  'rw_user1'@'localhost';
```





```
mysql> SET ROLE NONE; SELECT CURRENT_ROLE();
```


```
mysql> SET ROLE ALL EXCEPT 'app_write'; SELECT CURRENT_ROLE();
```


```
mysql> SET ROLE DEFAULT; SELECT CURRENT_ROLE();
```


```
REVOKE INSERT, UPDATE, DELETE ON app_db.* FROM 'app_write';
```


```
mysql> SHOW GRANTS FOR 'app_write';
```

REVOKE può anche essere applicato a un ruolo per modificare i privilegi ad esso concessi
```
REVOKE INSERT, UPDATE, DELETE ON app_db.* FROM 'app_write';
```


```
mysql> SHOW GRANTS FOR 'rw_user1'@'localhost'
       USING 'app_read', 'app_write';
```


```
GRANT INSERT, UPDATE, DELETE ON app_db.* TO 'app_write';
```


```
DROP ROLE 'app_read', 'app_write';
```
## IMPORTANTE Sicurezza: mysql database non deve essere accessibile dai non-root
Supponiamo di voler creare un utente u1con tutti i privilegi su tutti gli schemi, tranne che u1 dovrebbe essere un utente normale senza la possibilità di modificare gli account di sistema. Supponendo che la partial_revokesvariabile di sistema sia abilitata
```
CREATE USER u1 IDENTIFIED BY 'password';

GRANT ALL ON *.* TO u1 WITH GRANT OPTION;
-- GRANT ALL includes SYSTEM_USER, so at this point
-- u1 can manipulate system or regular accounts

REVOKE SYSTEM_USER ON *.* FROM u1;
-- Revoking SYSTEM_USER makes u1 a regular user;
-- now u1 can use account-management statements
-- to manipulate only regular accounts

REVOKE ALL ON mysql.* FROM u1;
-- This partial revoke prevents u1 from directly
-- modifying grant tables to manipulate accounts
```



