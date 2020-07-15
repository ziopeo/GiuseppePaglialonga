# Lab03 Hands-On MySQL 8.0




### Binary Log Exercise
Ripristino temporizzato mediante log binario

>Nota
Molti degli esempi in questa e nella prossima sezione usano il client mysql per elaborare l'output del log binario prodotto da mysqlbinlog . 
Se il tuo log binario contiene caratteri \0(null), quell'output non può essere analizzato da mysql a meno che tu non lo invochi con l'opzione --binary-mode .
Per consentire il ripristino di un server in un punto temporale, è necessario abilitare la registrazione binaria su di esso, che è l'impostazione predefinita per MySQL 8.0
Per ripristinare i dati dal log binario, è necessario conoscere il nome e il percorso dei file di log binari correnti. 
Per impostazione predefinita, il server crea file di log binari nella directory dei dati, ma è possibile specificare un nome percorso con l' opzione --log-bin per posizionare i file in una posizione diversa. 

Per visualizzare un elenco di tutti i file di log binari, utilizzare questa istruzione:
```
mysql> SHOW BINARY LOGS;
```
Per determinare il nome del file di log binario corrente, emettere la seguente dichiarazione:
```
mysql> SHOW MASTER STATUS;
```
L' utilità mysqlbinlog converte gli eventi nei file di log binari dal formato binario al testo in modo che possano essere visualizzati o applicati. 
mysqlbinlog ha opzioni per selezionare sezioni del log binario in base ai tempi degli eventi o alla posizione degli eventi all'interno del log. 
Vedere https://dev.mysql.com/doc/refman/8.0/en/mysqlbinlog.html

L'applicazione di eventi dal log binario comporta la riesecuzione delle modifiche ai dati che rappresentano. 
Ciò consente il recupero delle modifiche dei dati per un determinato lasso di tempo. 

Per applicare eventi dal log binario, elaborare l' output di mysqlbinlog utilizzando il client mysql 
```
shell> mysqlbinlog binlog_files | mysql -u root -p
```
Se i file di log binari sono stati crittografati, il che può essere fatto da MySQL 8.0.14 in poi, 
mysqlbinlog non può leggerli direttamente come nell'esempio precedente, ma può leggerli dal server usando l' opzione --read-from-remote-server ( -R). 
```
shell> mysqlbinlog --read-from-remote-server --host=host_name --port=3306  --user=root --password --ssl-mode=required  binlog_files | mysql -u root -p
```
Qui, l'opzione —ssl-mode=required è stata utilizzata per garantire che i dati dai file di log binari siano protetti durante il trasporto, poiché vengono inviati a mysqlbinlog in un formato non crittografato.
La visualizzazione del contenuto del log può essere utile quando è necessario determinare i tempi o le posizioni degli eventi per selezionare i contenuti del log parziale prima dell'esecuzione degli eventi. Per visualizzare gli eventi dal log, inviare l' output di mysqlbinlog in un programma di paging:
```
shell> mysqlbinlog binlog_files | more
```
In alternativa, salva l'output in un file e visualizza il file in un editor di testo:
```
shell> mysqlbinlog binlog_files > tmpfile
shell> ... edit tmpfile ...
```

Il salvataggio dell'output in un file è utile come preliminare all'esecuzione del contenuto del log con determinati eventi rimossi, come ad esempio un accidentale DROP TABLE. È possibile eliminare dal file qualsiasi istruzione da non eseguire prima di eseguirne il contenuto. Dopo aver modificato il file, applicare i contenuti come segue:
```
shell> mysql -u root -p < tmpfile
```
Se hai più di un log binario da applicare sul server MySQL, il metodo sicuro è quello di elaborarli tutti usando una singola connessione al server. 
Ecco un esempio che dimostra ciò che potrebbe non essere sicuro :
```
NON FARE
shell> mysqlbinlog binlog.000001 | mysql -u root -p # DANGER!!
shell> mysqlbinlog binlog.000002 | mysql -u root -p # DANGER!!
```

L'elaborazione dei logs binari in questo modo utilizzando connessioni diverse al server causa problemi se il primo file di log contiene 
un'istruzione CREATE TEMPORARY TABLE e il secondo log contiene un'istruzione che utilizza la tabella temporanea. 
Al termine del primo processo mysql , il server elimina la tabella temporanea. 
Quando il secondo processo mysql tenta di utilizzare la tabella, il server segnala " tabella sconosciuta. ”
Per evitare problemi come questo, utilizzare una singola connessione per applicare il contenuto di tutti i file di log binari che si desidera elaborare. 
Ecco un modo per farlo:
```
shell> mysqlbinlog binlog.000001 binlog.000002 | mysql -u root -p
```
È possibile reindirizzare l'output di mysqlbinlog nel client mysql per eseguire gli eventi contenuti nel log binario. 
Questa tecnica viene utilizzata per il ripristino da un arresto anomalo quando si dispone di un vecchio backup 
```
shell> mysqlbinlog binlog.000001 | mysql -u root -p
```

Un altro approccio è quello di scrivere l'intero log in un singolo file e quindi elaborare il file:
```
shell> mysqlbinlog binlog.000001 >  /tmp/statements.sql
shell> mysqlbinlog binlog.000002 >> /tmp/statements.sql
shell> mysql -u root -p -e "source /tmp/statements.sql"
```


Quando si scrive su un file di dump mentre si legge un punto di ripristino da un log binario contenente GTID utilizzare l'opzione --skip-gtids  con mysqlbinlog 
```
shell> mysqlbinlog --skip-gtids binlog.000001 >  /tmp/dump.sql
shell> mysqlbinlog --skip-gtids binlog.000002 >> /tmp/dump.sql
shell> mysql -u root -p -e "source /tmp/dump.sql"
```

Inizia a leggere il log binario al primo evento con un timestamp uguale o successivo all'argomento datetime. 
Il valore datetime è relativo al fuso orario locale sul computer su cui si esegue mysqlbinlog . 
Il valore deve essere in un formato accettato per i tipi di dati DATETIME o TIMESTAMP. Per esempio:
```
shell> mysqlbinlog --start-datetime="2005-12-25 11:25:56" binlog.000003
```
Per indicare l'ora di inizio e di fine per il recupero, specificare le opzioni --start-datetimee --stop-datetime per mysqlbinlog nel formato DATETIME. 
Ad esempio, supponiamo che esattamente alle 10:00 del 20 aprile 2005 sia stata eseguita un'istruzione SQL che ha eliminato una tabella di grandi dimensioni. 
Per ripristinare la tabella e i dati, è possibile ripristinare il backup della notte precedente, quindi eseguire il comando seguente:
```
shell> mysqlbinlog --stop-datetime="2005-04-20 9:59:59" /var/log/mysql/bin.0001 | mysql -u root -p
```
### Esercizio: 
Utilizzare mysqlbinlog per eseguire un backup continuo del log binario:

```terminal
shell> mysqlbinlog --read-from-remote-server --host=host_name --raw
  --stop-never binlog.000999
```
Utilizzare mysqldump per creare un file di dump come un'istantanea dei dati del server. Utilizzare `--all-databases`, `--events` e --routines per eseguire il backup di tutti i dati e  --master-data=2 per includere le coordinate del log binario correnti nel file di dump.

```terminal
mysqldump --host=host_name --all-databases --events --routines --master-data=2> dump_file
```

Eseguire periodicamente il comando mysqldump per creare istantanee più recenti multiple.

Se si verifica una perdita di dati (ad esempio, se il server si arresta in modo anomalo), utilizzare il file di dump più recente per ripristinare i dati:

```terminal
mysql --host=host_name -u root -p < dump_file
```

Quindi utilizzare il backup del log binario per rieseguire gli eventi scritti dopo le coordinate elencate nel file di dump. 
Supponiamo che le coordinate nel file siano così:

>-- CHANGE MASTER TO MASTER_LOG_FILE='binlog.001002', MASTER_LOG_POS=27284;

Se viene chiamato il file di log di backup più recente `binlog.00004`, riesegui gli eventi di log in questo modo:

```terminal
mysqlbinlog --start-position=27284 binlog.00002 binlog.00003 binlog.00004
  | mysql --host=host_name -u root -p
```



### Opzioni e variabili relative alla sicurezza
https://dev.mysql.com/doc/refman/8.0/en/security-options.html 



```
shell> telnet server_host 3306
```

```
shell> tcpdump -l -i eth0 -w - src or dst port 3306 | strings
```

Dopo aver creato il file .myconf.cnf con mysql_config_editor nella home, assicurarsi che i permessi siano impostati
Anche .mysql_history che contiene la cronologia di comandi va protetto
```
chmod 600 .myconf.cnf
```

Per denominare dalla riga di comando un file di opzioni specifico contenente la password, utilizzare l' opzione, dove è il nome completo del percorso del file. P --defaults-file=file_namefile
```
shell> mysql --defaults-file=/home/studente/tuofilediopzioni
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
### REPLACE viene omesso dal log binario per evitare di scrivere password in chiaro.

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
mysql> EXPLAIN SELECT * FROM t1 WHERE t1.a > (SELECT COUNT(a) FROM t2)\G
```

SHOW WARNINGSè un'istruzione diagnostica che visualizza informazioni sulle condizioni (errori, avvisi e note) risultanti dall'esecuzione di un'istruzione nella sessione corrente. Avvisi vengono generati per istruzioni DML come INSERT, UPDATE  LOAD DATA così come DDL come CREATE TABLE e ALTER TABLE.
Sintassi
```
SHOW WARNINGS [LIMIT [offset,] row_count]
SHOW COUNT(*) WARNINGS
```

LA SHOW COUNT(*) WARNINGS è istruzione diagnostica che mostra il numero totale di errori, avvisi e note. 
Puoi anche recuperare questo numero dalla variabile di sistema warning_count

```
SHOW COUNT(*) WARNINGS;
SELECT @@warning_count;
```


# SQL-modes
Per modificare la modalità SQL in fase di runtime, impostare la sql_modevariabile di sistema globale o di sessione utilizzando SET un'istruzione:


```
SET GLOBAL sql_mode = 'modes';
SET SESSION sql_mode = 'modes';
```

P.s. L'impostazione della variabile  GLOBAL richiede il privilegio SYSTEM_VARIABLES_ADMIN (o il SUPER privilegio deprecato ) e influisce sul funzionamento di tutti i client che si connettono da quel momento in poi
Per determinare l'impostazione globale sql_mode o della sessione corrente 
```
SELECT @@GLOBAL.sql_mode;
SELECT @@SESSION.sql_mode;
```


>## Importante
>La modifica della modalità SQL del server dopo la creazione e l'inserimento di dati in tabelle partizionate può causare importanti cambiamenti nel comportamento di tali tabelle e può portare alla perdita o al danneggiamento dei dati. 
>### Si consiglia vivamente di non modificare mai la modalità SQL dopo aver creato le tabelle utilizzando il partizionamento definito dall'utente.
>
>Durante la replica di tabelle partizionate, anche diverse modalità SQL sul master e sullo slave possono causare problemi. Per risultati ottimali, è necessario utilizzare sempre la stessa modalità SQL del server sul master e sullo slave.

```

```


```

```


```

```


```

```


```

```




