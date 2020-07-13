



```
mysql> SHOW TABLES;
Empty set (0.00 sec)
```

```
mysql> CREATE TABLE pet (name VARCHAR(20), owner VARCHAR(20),
       species VARCHAR(20), sex CHAR(1), birth DATE, death DATE);
```

```
mysql> SHOW TABLES;
+---------------------+
| Tables in menagerie |
+---------------------+
| pet                 |
+---------------------+
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
mysql> DELETE FROM pet;
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
mysql> SELECT name, species, birth FROM pet
       WHERE species = 'dog' OR species = 'cat';
```


```
mysql> SELECT name, birth FROM pet ORDER BY birth;
```


```
mysql> SELECT name, birth FROM pet ORDER BY birth DESC;
```


```
mysql> SELECT name, species, birth FROM pet
       ORDER BY species, birth DESC;
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


```
SELECT MAX(birth) AS young FROM pet;
```

Variabili d'ambiente
```
mysql> SELECT @old_pet:=MIN(birth),@young_pet:=MAX(birth) FROM pet;
```


Inserimento di chiavi esterne

```
CREATE TABLE person (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name CHAR(60) NOT NULL,
    PRIMARY KEY (id)
);
```


```
CREATE TABLE shirt (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    style ENUM('t-shirt', 'polo', 'dress') NOT NULL,
    color ENUM('red', 'blue', 'orange', 'white', 'black') NOT NULL,
    owner SMALLINT UNSIGNED NOT NULL REFERENCES person(id),
    PRIMARY KEY (id)
);
```


```
INSERT INTO person VALUES (NULL, 'Antonio Paz');
```


```
SELECT @last := LAST_INSERT_ID();
```


```
INSERT INTO shirt VALUES
(NULL, 'polo', 'blue', @last),
(NULL, 'dress', 'white', @last),
(NULL, 't-shirt', 'blue', @last);
```


```
INSERT INTO person VALUES (NULL, 'Lilliana Angelovska');
```


```
INSERT INTO shirt VALUES
(NULL, 'dress', 'orange', @last),
(NULL, 'polo', 'red', @last),
(NULL, 'dress', 'blue', @last),
(NULL, 't-shirt', 'white', @last);
```


```
SELECT * FROM person;
```


```
SELECT * FROM shirt;
```


```
SELECT s.* FROM person p INNER JOIN shirt s
   ON s.owner = p.id
 WHERE p.name LIKE 'Lilliana%'
   AND s.color <> 'white';
```

AUTO-INCREMENT
```
CREATE TABLE animals (
     id MEDIUMINT NOT NULL AUTO_INCREMENT,
     name CHAR(30) NOT NULL,
     PRIMARY KEY (id)
);
```


```
INSERT INTO animals (name) VALUES
    ('dog'),('cat'),('penguin'),
    ('lax'),('whale'),('ostrich');
```


```
SELECT * FROM animals;
```

Per iniziare con un AUTO_INCREMENTvalore diverso da 1, impostare quel valore con CREATE TABLE o ALTER TABLE, 
```
mysql> ALTER TABLE tbl AUTO_INCREMENT = 100;
```
***

Il server MySQL ha alcune opzioni di comando che possono essere specificate solo all'avvio e una serie di variabili di sistema, alcune delle quali possono essere impostate all'avvio, in fase di esecuzione o in entrambi.
Set variabile di sistema general_log
```
SET GLOBAL general_log = ON;
SELECT @@GLOBAL.general_log;
```

Il comando seguente dice a mysqladmin di eseguire il ping del server 1024 volte, dormendo 10 secondi tra ogni ping:
```
mysqladmin --count=1K --sleep=10 ping
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

>Account riservati
>Una parte del processo di installazione di MySQL è l'inizializzazione della directory dei dati (vedere Sezione 2.10.1, "Inizializzazione della directory dei dati" ). Durante l'inizializzazione della directory dei dati, MySQL crea account utente che devono essere considerati riservati: 'root'@'localhost: Utilizzato a fini amministrativi. Questo account ha tutti i privilegi, è un account di sistema e può eseguire qualsiasi operazione.
>A rigor di termini, questo nome account non è riservato, nel senso che alcune installazioni rinominano l' rootaccount in qualcos'altro per evitare di esporre un account altamente privilegiato con un nome noto.
>'mysql.sys'@'localhost': Utilizzato come DEFINERper gli sysoggetti dello schema. L'uso mysql.sysdell'account evita problemi che si verificano se un DBA rinomina o rimuove l' root account. Questo account è bloccato in modo che non possa essere utilizzato per le connessioni client.
>'mysql.session'@'localhost': Utilizzato internamente dai plugin per accedere al server. Questo account è bloccato in modo che non possa essere utilizzato per le connessioni client. L'account è un account di sistema.
>'mysql.infoschema'@'localhost': Usato come DEFINERper le INFORMATION_SCHEMAviste. L'uso mysql.infoschemadell'account evita i problemi che si verificano se un DBA rinomina o rimuove l'account root. Questo account è bloccato in modo che non possa essere utilizzato per le connessioni client.




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



