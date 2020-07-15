 # Lab01 Hands-On MySQL 8.0



Verifica se è già presente un'installazione di mysql


 Link documentazione https://dev.mysql.com/doc/
 Link glossario: https://dev.mysql.com/doc/mysql-enterprise-backup/8.0/en/glossary.htm
***
#### Controlliamo la versione della macchina in uso
```
 $ cat /etc/issue
```
>Abbiamo a disposizione una macchina Ubuntu versione 18
***
#### Controllo versioni precedenti MySQL installate 

```
 $ ps x | grep mysql
 $ whereis mysql
```
>Se non otteniamo nessun risultato (a parte il processo di grep relativo a mysql)
possiamo essere sicuri che non è installata nessuna versione di mysql.
***

#### Installiamo la libreria libaio1 
>La libreria "libaio" è necessaria all'installazione
```
  $ sudo apt-get install libaio1
```
***

#### Aggiorniamo 

```
  $ sudo apt-get update
  $ sudo apt-get upgrade
```
***
#### Procediamo all'installazione del server MySQL
```
  $ sudo apt-get install mysql-server
```
Diamo 'Y' alle varie domande che il software ci chiede e inseriamo la password di root per il database (RECOMMENDED)
****
#### Verificare lo stato del processo mysql

```
  $ sudo service mysql status
```
***
#### Fermare il server
```
  $ sudo service mysql stop
```
***
#### Avviare il server
In Ubuntu
```
  $ sudo service mysql start
```
Altre distribuzioni
```
  $ sudo service mysqld start
```
***
#### Riavviare il server
```
  $ sudo service mysql restart
```
***
#### Verifica della versione installata
```
  $ mysql -V
```
>Tutti file di configurazione(come my.cnf): /etc/mysql
>Data-Directory: /var/lib/mysql
>Tutti i file binari, le librerie, gli headers, ecc. Sono sotto `/usr/bin`e `/usr/sbin`
```
  $ sudo ls /var/lib/mysql
```
#### Mettere in sicurezza l'installazione
```
  $ sudo mysql_secure_installation
```
>A "VALIDATE PASSWORD COMPONENT" rispondiamo "No"
A "Using existing password for root" scegliamo "No" (L'abbiamo già impostata)
A "Remove anonymous users" scriviamo Y
A "Disable root login remotely" scriviamo Y

***
#### Accesso al server MySQL

```
   $ sudo mysqld_safe 
```
#### Creazione dell'utente
Procediamo ora alla creazione di un nuovo utente:
```
   mysql> CREATE USER 'studente'@'localhost' IDENTIFIED BY 'password';
```
Assegniamo i permessi di accesso al nuovo studente:
```
   mysql> GRANT ALL PRIVILEGES ON * . * TO 'studente'@'localhost';
```
Flush dei permessi per rendere effettive le modiche
```
   mysql> FLUSH PRIVILEGES;
```



Aggiunta del nostro user al gruppo mysql per poter accedere alla Data-Directory
```
  $ sudo usermod -g mysql student
```

Effettuiamo il logout per rendere effettive le modifiche
```
  $ exit
```
Clicchiamo su Reconnect per riconnetterci al server
***
#### Testare il server
Usiamo l'applicazione mysqladmin fornita nel pacchetto.
>Digitiamo questi comandi per verificare se il server è attivo e risponde alle connessione
```
	$ mysqladmin -u studente -p version
```
```
	$ mysqladmin -u studente -p variables
```
Help di mysqladmin:
```
	$ mysqladmin -u studente -p --help
```


***
Verifica veloce dei dati esistenti nella base di dati
```
	$ mysqlshow -u studente -p mysql
```

```
	$ mysql -u studente -p -e  "SELECT User, Host, plugin FROM mysql.user" mysql
```
***
Verifica arresto MySQL

```
	$ mysqladmin  -u root -p shutdown
```

****
### Storage Engine
```
mysql> SHOW TABLE STATUS \G;
mysql> SHOW ENGINE \G;
mysql> CREATE TABLE table1 (i1 INT) ENGINE = INNODB;
mysql> CREATE TABLE table2 (i2 INT) ENGINE = CSV;
mysql> CREATE TABLE table3 (i3 INT) ENGINE = MEMORY;
```
Cambiare lo storage engine di una tabella
```
mysql> ALTER TABLE table3 ENGINE = InnoDB;
```
Cambiare storage engine
```
mysql> SET default_storage_engine=MEMORY;
```
Informazioni sull'InnoDb INFORMATION_SCHEMA
```
mysql> SHOW TABLES FROM INFORMATION_SCHEMA LIKE 'INNODB%';
```

### Creazione e uso dei databases
### Creazione tabelle
### Ottenere e inserire dati dalla e nella base di dati





***
# Aggiornamento da MySQL 5.7 a MySQL 8

https://dev.mysql.com/doc/mysql-apt-repo-quick-guide/en/


#### Prepariamo l'aggiornamento che effettueremo usando MySQL Apt Repository
```
  $ mysqlcheck -u root -p --all-databases --check-upgrade
```
Verifichiamo che l'output sia ok
***
Verifichiamo che non ci siano tabelle che non supportano il native partitioning
```
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE ENGINE NOT IN ('innodb', 'ndbcluster')
AND CREATE_OPTIONS LIKE '%partitioned%';
```
Se l'output dà l'insieme vuoto possiamo continuare.

Altrimenti:
```
ALTER TABLE table_name ENGINE = INNODB;
ALTER TABLE table_name REMOVE PARTITIONING;
```
***

Controlliamo che la lunghezza dei caratteri delle chiavi esterne dei vincoli di integrità non superi i 64 caratteri in quanto non consentito in MySQL 8
```
SELECT CONSTRAINT_SCHEMA, TABLE_NAME, CONSTRAINT_NAME
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS
WHERE LENGTH(CONSTRAINT_NAME) > 64;
```

Se il risultato è l'insieme vuoto possiamo proseguire altrimenti dobbiamo correggere.


Posizionamoci nella home
```
  $ cd
```
\
Creiamo una cartella "aggiornamento"
```
  $ mkdir aggiornamento
```

>Installeremo MySQL tramite MySQL Apt Repository
Scarichiamo il pacchetto deb per aggiungere MySQL8 al repository
```
  $ wget "https://dev.mysql.com/get/mysql-apt-config_0.8.15-1_all.deb"
```

Installiamo il pacchetto .deb appena scaricato
```
  $ sudo dpkg -i mysql-apt-config_0.8.15-1_all.deb
```
Sempre a terminale, si presenterà un'interfaccia "grafica" con cui potete selezionare le opzioni d'installazione.
Selezioniamo MySQL 8, Ok e poi INVIO.
***
Aggiornamento repository.
```
  $ sudo apt-get update
```
***
```
  $ sudo apt-get install mysql-server
```


***
```
  $ mysql -V
```
ps. non usiamo mysql_upgrade perchè nella versione odierna 8.0.20, le sue funzionalità sono state integrate nel processo di aggiornamento
***




***
```
mysql> SELECT VERSION(), CURRENT_DATE;
```

```
mysql> select version(), current_date;
```
```
mysql> SeLeCt vErSiOn(), current_DATE;
```
```
mysql> SELECT VERSION(); SELECT NOW();
```
```
mysql> SELECT
    -> USER()
    -> ,
    -> CURRENT_DATE;
```
```
mysql> SHOW DATABASES;
```
```
mysql> CREATE DATABASE menagerie;
```

```
mysql> USE menagerie;
```
```
mysql> SHOW TABLES;
```
```
mysql> CREATE TABLE pet (name VARCHAR(20), owner VARCHAR(20),
       species VARCHAR(20), sex CHAR(1), birth DATE, death DATE);
```
```
mysql> DESCRIBE pet;
```
E' possibile importare un file strutturato(es .csv)
```
mysql> LOAD DATA LOCAL INFILE '/path/pet.txt' INTO TABLE pet;
```
```
mysql> INSERT INTO pet VALUES ('Puffball','Diane','hamster','f','1999-03-30',NULL);
```
Creaiamone una 10ina random per popolare il database
```
mysql>UPDATE pet SET birth = '2009-08-31' WHERE name = 'Puffball';
```

```
mysql> SELECT * FROM pet WHERE birth >= '2008-1-1';
```
```
mysql> name, birth FROM pet ORDER BY birth;
```
```
mysql> SELECT name, species, birth FROM pet
       ORDER BY species, birth DESC;
```
```
mysql> SELECT * FROM pet WHERE name LIKE 'P%';
```
***
Uso di mysql in batch mode
```
shell> mysql < batch-file
```
```
shell> mysql -h host -u user -p < batch-file
```
```
  $ mysql -V
```
****
Massimo valore di una colonna
```
mysql>SELECT MAX(birth) AS young FROM pet;
```

***

Variabili definite dall’utente per ricordare i risultati

```
mysql> SELECT @min_eta:=MAX(birth),@max_eta:=MIN(birth) FROM pet;
```
***
Vincoli di integrità referenziale e chiavi esterne
```
CREATE TABLE person (
    id SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name CHAR(60) NOT NULL,
    PRIMARY KEY (id)
);

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
SELECT @last := LAST_INSERT_ID();
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
SELECT * FROM shirt;
```
```
SELECT s.* FROM person p INNER JOIN shirt s
   ON s.owner = p.id
 WHERE p.name LIKE 'Lilliana%'
   AND s.color <> 'white';
```
```
SHOW CREATE TABLE shirt\G
```

***
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
```
INSERT INTO animals (id,name) VALUES(0,'groundhog');
```
```
INSERT INTO animals (id,name) VALUES(NULL,'squirrel');
```
```
INSERT INTO animals (id,name) VALUES(100,'rabbit');
INSERT INTO animals (id,name) VALUES(NULL,'mouse');
SELECT * FROM animals;
```


