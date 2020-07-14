### Opzioni e variabili relative alla sicurezza
https://dev.mysql.com/doc/refman/8.0/en/security-options.html 



````
shell> telnet server_host 3306
````

```
shell> tcpdump -l -i eth0 -w - src or dst port 3306 | strings
```

Dopo aver creato il file .myconf.cnf con mysql_config_editor nella home, assicurarsi che i permessi siano impostati
Anche .mysql_history che contiene la cronologia di comandi va protetto
```
chmod 600 .myconf.cnf
```

Per denominare dalla riga di comando un file di opzioni specifico contenente la password, utilizzare l' opzione, dove è il nome completo del percorso del file. P --defaults-file=file_namefile
```
shell> mysql --defaults-file=/home/francis/tuofilediopzioni
```

Per rendere una password scaduta, quindi da reimpostare
```
ALTER USER 'studente'@'localhost' PASSWORD EXPIRE
```



Per stabilire una politica globale in base alla quale le password hanno una durata di circa sei mesi, 
avviare il server con queste righe in un my.cnf file:
```
[mysqld]
default_password_lifetime=180
```

Per stabilire una politica globale in modo tale che le password non scadano mai, impostare default_password_lifetime su 0:
```
[mysqld]
default_password_lifetime=0
```

default_password_lifetime può anche essere impostato e persistente in fase di esecuzione:
```
SET PERSIST default_password_lifetime = 180;
SET PERSIST default_password_lifetime = 0;

```


Modificare la password ogni 90 giorni
```
CREATE USER 'jeffrey'@'localhost' PASSWORD EXPIRE INTERVAL 90 DAY;
ALTER USER 'jeffrey'@'localhost' PASSWORD EXPIRE INTERVAL 90 DAY;
```


Disabilita scadenza password
```
ALTER USER 'jeffrey'@'localhost' PASSWORD EXPIRE NEVER;
```

Il classico errore se la password scaduta con relativa soluzione
```
mysql> SELECT 1;
ERROR 1820 (HY000): You must reset your password using ALTER USER
statement before executing this statement.

mysql> ALTER USER USER() IDENTIFIED BY 'password';
```

Per vietare il riutilizzo di una qualsiasi delle ultime 6 password o password più recenti di 365 giorni, inserire queste righe nel my.cnf
```
[mysqld]
password_history=6
password_reuse_interval=365
```

Per impostare in fase di runtime
```
SET PERSIST password_history = 6;
SET PERSIST password_reuse_interval = 365;
```

Richiede almeno 365 giorni trascorsi prima di consentire il riutilizzo:
```
ALTER USER 'jeffrey'@'localhost' PASSWORD REUSE INTERVAL 365 DAY;
```

Richiede un minimo di 5 modifiche alla password prima di consentire il riutilizzo:

```
ALTER USER 'jeffrey'@'localhost' PASSWORD HISTORY 5;
```

Per combinare entrambi i tipi di restrizioni sul riutilizzo, utilizzare PASSWORD HISTORYe PASSWORD REUSE INTERVALinsieme:
```
ALTER USER 'jeffrey'@'localhost'
  PASSWORD HISTORY 5
  PASSWORD REUSE INTERVAL 365 DAY;
ALTER USER 'jeffrey'@'localhost'
  PASSWORD HISTORY 5
  PASSWORD REUSE INTERVAL 365 DAY;```
```


Ristabilire la politica globale
```

ALTER USER 'jeffrey'@'localhost'
  PASSWORD HISTORY DEFAULT
  PASSWORD REUSE INTERVAL DEFAULT;
```

Per stabilire una politica globale secondo cui le modifiche alla password devono specificare la password corrente
```
[mysqld]
password_require_current=ON
```


```
SET PERSIST password_require_current = ON;
SET PERSIST password_require_current = OFF;
```

Richiedere la password corrente quando il singolo utente la modifica
```
ALTER USER 'jeffrey'@'localhost' PASSWORD REQUIRE CURRENT;```
```

Senza richiedere la password corrente quando si modifica il singolo utente
```
ALTER USER 'jeffrey'@'localhost' PASSWORD REQUIRE CURRENT OPTIONAL;
```

La verifica della password corrente entra in gioco quando un utente cambia una password usando l' istruzione ALTER USER o SET PASSWORD. 




Modifica la password dell'utente corrente:
```
ALTER USER USER() IDENTIFIED BY 'auth_string' REPLACE 'current_auth_string';
```

Modifica la password di un utente
```
ALTER USER 'jeffrey'@'localhost'
  IDENTIFIED BY 'auth_string'
  REPLACE 'current_auth_string';
```

Modifica il plug-in di autenticazione e la password di un utente 
```
ALTER USER 'jeffrey'@'localhost'
  IDENTIFIED WITH caching_sha2_password BY 'auth_string'
  REPLACE 'current_auth_string';
```
### N.B REPLACE può essere specificato solo quando si modifica la password dell'account per l'utente corrente.
### REPLACE viene omesso dal registro binario per evitare di scrivere password in chiaro.

## Supporto per doppia password
A partire da MySQL 8.0.14, gli account utente possono avere due password, designate come password primarie e secondarie. 
RETAIN CURRENT PASSWORD mantiene una password corrente dell'account come password secondaria
Privilegi richiesti: APPLICATION_PASSWORD_ADMIN
### Esempio 
Su ciascun server che non è uno slave di replica, stabilire come nuova password primaria, mantenendo la password corrente come password secondaria
```
ALTER USER 'appuser1'@'host1.example.com'
  IDENTIFIED BY 'password_b'
  RETAIN CURRENT PASSWORD;
```

questo punto, la password secondaria non è più necessaria. Su ogni server che non è uno slave di replica, scartare la password secondaria:
```
ALTER USER 'appuser1'@'host1.example.com'
  DISCARD OLD PASSWORD;
```


```
mysql> CREATE USER
       'u1'@'localhost' IDENTIFIED BY RANDOM PASSWORD,
       'u2'@'%.example.com' IDENTIFIED BY RANDOM PASSWORD,
       'u3'@'%.org' IDENTIFIED BY RANDOM PASSWORD;
+------+---------------+----------------------+
| user | host          | generated password   |
+------+---------------+----------------------+
| u1   | localhost     | BA;42VpXqQ@i+y{&TDFF |
| u2   | %.example.com | YX5>XRAJRP@>sn9azmD4 |
| u3   | %.org         | ;GfD44l,)C}PI/6)4TwZ |
+------+---------------+----------------------+
mysql> ALTER USER
       'u1'@'localhost' IDENTIFIED BY RANDOM PASSWORD,
       'u2'@'%.example.com' IDENTIFIED BY RANDOM PASSWORD;
+------+---------------+----------------------+
| user | host          | generated password   |
+------+---------------+----------------------+
| u1   | localhost     | yhXBrBp.;Y6abB)e_UWr |
| u2   | %.example.com | >M-vmjp9DTY6}hkp,RcC |
+------+---------------+----------------------+
mysql> SET PASSWORD FOR 'u3'@'%.org' TO RANDOM;
+------+-------+----------------------+
| user | host  | generated password   |
+------+-------+----------------------+
| u3   | %.org | o(._oNn)d;FC<vJIDg9M |
+------+-------+----------------------+

```
Il numero di accessi non riusciti e il tempo di blocco sono configurabili per ogni conto, utilizzando la FAILED_LOGIN_ATTEMPTS e PASSWORD_LOCK_TIME

```
CREATE USER 'u1'@'localhost' IDENTIFIED BY 'password'
  FAILED_LOGIN_ATTEMPTS 3 PASSWORD_LOCK_TIME 3;

ALTER USER 'u2'@'localhost'
  FAILED_LOGIN_ATTEMPTS 4 PASSWORD_LOCK_TIME UNBOUNDED;
```


```
ERROR 3957 (HY000): Access denied for user user.
Account is blocked for D day(s) (R day(s) remaining)
due to N consecutive failed logins
```

Per avviare automaticamente il server come utente specificato all'avvio del sistema, specificare il nome utente aggiungendo un'opzione user a my.cnf. Per esempio:
```
[mysqld]
user=user_name
```
# OTTIMIZZAZIONE

```
mysql> SELECT @@optimizer_switch \G;
```


```
mysql> CREATE TABLE t1(a INT);

mysql> CREATE TABLE t2(a INT);

mysql> INSERT INTO t1 VALUES ROW(1), ROW(2), ROW(3), ROW(4);

mysql> INSERT INTO t2 VALUES ROW(1), ROW(2);

mysql> SELECT * FROM t1
    ->     WHERE t1.a > (SELECT COUNT(a) FROM t2);
```


```
mysql> SELECT @@optimizer_switch LIKE '%subquery_to_derived=off%';
```


```
mysql> EXPLAIN SELECT * FROM t1 WHERE t1.a > (SELECT COUNT(a) FROM t2)\G
```


```
mysql> SET @@optimizer_switch='subquery_to_derived=on';
```


```
mysql> SELECT @@optimizer_switch LIKE '%subquery_to_derived=off%'
```


```
mysql> SELECT @@optimizer_switch LIKE '%subquery_to_derived=on%';
```


```
mysql> EXPLAIN SELECT * FROM t1 WHERE t1.a > (SELECT COUNT(a) FROM t2)\G```


```

```


```

```


