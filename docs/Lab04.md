# Lab04 Hands-On MySQL 8.0


```
SHOW ENGINE INNODB STATUS
```


```
mysql>  SELECT  NAME,  COMMENT  FROM INFORMATION_SCHEMA.INNODB_METRICS WHERE  NAME  LIKE  '%ibuf%'\G
```


```
mysql>  SELECT  *  FROM performance_schema.setup_instruments WHERE  NAME  LIKE  '%wait/synch/mutex/innodb/ibuf%';
```

```
mysql>  SELECT  (SELECT  COUNT(*)  FROM INFORMATION_SCHEMA.INNODB_BUFFER_PAGE WHERE PAGE_TYPE LIKE  'IBUF%')  AS change_buffer_pages, 
(SELECT  COUNT(*)  FROM INFORMATION_SCHEMA.INNODB_BUFFER_PAGE)  AS total_pages,
(SELECT  ((change_buffer_pages/total_pages)*100))
AS change_buffer_page_percentage;
```
```
mysql>  SELECT  @@optimizer_switch\G
```
```
SET  GLOBAL optimizer_switch='';
```

```
mysql>  CREATE  TABLE t1(a INT);  
```

```
mysql>  CREATE  TABLE t2(a INT);  
```

```
mysql>  INSERT  INTO t1 VALUES  ROW(1),  ROW(2),  ROW(3),  ROW(4);  
```

```
mysql>  INSERT  INTO t2 VALUES  ROW(1),  ROW(2);  
```
```
mysql>  SELECT  *  FROM t1  WHERE t1.a >  (SELECT  COUNT(a)  FROM t2);
```
```
mysql>  SELECT  @@optimizer_switch  LIKE  '%subquery_to_derived=off%';
```
```
mysql>  EXPLAIN  SELECT  *  FROM t1 WHERE t1.a >  (SELECT  COUNT(a)  FROM t2)\G
```
```
mysql>  SET  @@optimizer_switch='subquery_to_derived=on';
```
```
mysql>  SELECT  @@optimizer_switch  LIKE  '%subquery_to_derived=off%';
```
```
mysql>  SELECT  @@optimizer_switch  LIKE  '%subquery_to_derived=on%';
```
```
mysql>  EXPLAIN  SELECT  *  FROM t1 WHERE t1.a >  (SELECT  COUNT(a)  FROM t2)\G
```


```
mysql>  DROP  TABLE  IF  EXISTS t1, t2;
```
```
mysql>  CREATE  TABLE t1 (a INT, b INT);  
```
```
mysql>  CREATE  TABLE t2 (a INT, b INT);  
```
```
mysql>  INSERT  INTO t1 VALUES  ROW(1,10),  ROW(2,20),  ROW(3,30);  
```
```
mysql>  INSERT  INTO t2 VALUES  ROW(1,10),  ROW(2,20),  ROW(3,30),  ROW(1,110),  ROW(2,120),  ROW(3,130);
```

```
mysql>  SELECT  *  FROM t1 WHERE t1.b <  0 OR t1.a IN  (SELECT t2.a +  1  FROM t2);
```
```
mysql>  SET  @@optimizer_switch="subquery_to_derived=off";
```
```
mysql> EXPLAIN  SELECT  *  FROM t1   WHERE t1.b <  0   OR   t1.a IN  (SELECT t2.a +  1  FROM t2)\G
```

```
mysql>  SET  @@optimizer_switch="subquery_to_derived=on";
```

```
mysql>  SHOW  WARNINGS\G
```
//relativa a show warnings SHOW  VARIABLES  LIKE  'max_error_count';
```
mysql>  EXPLAIN  SELECT  *  FROM t1   WHERE t1.b <  0    OR   t1.a IN  (SELECT t2.a +  1  FROM t2)\G
```
```
mysql>  SELECT  *  FROM t1   WHERE t1.b <  0    OR    EXISTS(SELECT  *  FROM t2 WHERE t2.a = t1.a +  1);
```
```
mysql>  SET  @@optimizer_switch="subquery_to_derived=off";
```
```
mysql>  EXPLAIN  SELECT  *  FROM t1  WHERE t1.b <  0   OR  EXISTS(SELECT  *  FROM t2 WHERE t2.a = t1.a +  1)\G
```
```
mysql>  SET  @@optimizer_switch="subquery_to_derived=on";
```
```
mysql>  EXPLAIN  SELECT  *  FROM t1   WHERE t1.b <  0    OR    EXISTS(SELECT  *  FROM t2 WHERE t2.a = t1.a +  1)\G
```
```
mysql>  SHOW  WARNINGS\G
```


```
shell> mysqldump  --single-transaction  --flush-logs  --master-data=2 \

--all-databases > backup_sunday_1_PM.sql
```
Per creare un nuovo file di log binario 
```
mysqladmin flush-logs
```
Indica dopo quanto tempo il server cancella i log binary
`binlog_expire_logs_seconds`


>PRIMA DI PROCEDERE LEGGERE
>**Nota** L'eliminazione dei logs binari di MySQL con mysqldump --delete-master-logs può essere pericolosa se il server è un server master di replica, poiché i server slave potrebbero non aver ancora completamente elaborato il contenuto del log binario. 
>1.  Su ogni replica, utilizzare `SHOW SLAVE STATUS`per verificare quale file di registro sta leggendo.
    
>2.  Ottenere un elenco dei file di registro binari sull'origine con `SHOW BINARY LOGS`
    
>3.  Determinare il primo file di registro tra tutte le repliche. Questo è il file di destinazione. Se tutte le repliche sono aggiornate, questo è l'ultimo file di registro nell'elenco.
    
>4.  Eseguire un backup di tutti i file di registro che si sta per eliminare. (Questo passaggio è facoltativo, ma sempre consigliabile.)
    
>5.  Elimina tutti i file di registro fino a ma non includendo il file di destinazione.

Possiamo cancellare i log binary se occupano troppo spazio dopo aver fatto un
backup completo
```
shell> mysqldump  --single-transaction  --flush-logs  --master-data=2 \

--all-databases  --delete-master-logs > backup_sunday_1_PM.sql
```
simile a 
```
PURGE  BINARY  LOGS  TO  'mysql-bin.010';  
PURGE  BINARY  LOGS  BEFORE  '2019-04-02 22:46:26';
```


Per eseguire il dump delle tabelle in formato valori separati da virgola con righe terminate da coppie \r\n
```
shell> mysqldump  --tab=/tmp  --fields-terminated-by=,

--fields-enclosed-by='"'  --lines-terminated-by=0x0d0a db1
```
Copia database
```
shell> mysqldump db1 > dump.sql

shell> mysqladmin create db2

shell> mysql db2 < dump.sql
```

Esercizio
Migra database



Sul server 1:
```
shell> mysqldump  --databases db1 > dump.sql
```
  

Copia il file di dump dal Server 1 al Server 2.
N.B. per copiare da un nodo all'altro utilizzare il comando 'scp' e ifconfig per verificare gli ip

Sul server 2:
```
shell> mysql < dump.sql
```

Sul server 1:
```
shell> mysqldump db1 > dump.sql
```
  

Sul server 2:
```
shell> mysqladmin create db1

shell> mysql db1 < dump.sql
```





Questo ID server viene utilizzato per identificare i singoli server nella topologia di replica e deve essere un numero intero positivo compreso tra 1 e (2 32 ) −1. Il [`server_id`]valore predefinito di MySQL 8.0 è 1. È possibile modificare il [`server_id`] in modo dinamico emettendo un'istruzione come questa:






```sql
SET GLOBAL server_id = 2;
```
oppure
Il [`server_id`] predefinito è 1. È possibile modificare il [`server_id`] a runtime emettendo un'istruzione come questa:

```sql
SET GLOBAL server_id = 21;
```

Se si sta chiudendo il server di replica, è possibile modificare la `[mysqld]`sezione del file di configurazione per specificare un ID server univoco. Per esempio:

```ini
[mysqld]
server-id=21
```

Per creare un nuovo account, utilizzare [`CREATE USER`]. Per concedere a questo account i privilegi richiesti per la replica, utilizzare [`GRANT`] . Se si crea un account esclusivamente ai fini della replica, tale account necessita solo del privilegio [`REPLICATION SLAVE`]. Ad esempio, per configurare un nuovo utente, `repl`che può connettersi per la replica da qualsiasi host all'interno del `example.com`dominio, emettere queste dichiarazioni sull'origine:

```sql
mysql> CREATE USER 'repl'@'%.example.com' IDENTIFIED BY 'password';
mysql> GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%.example.com';
```

Avviare una sessione sull'origine connettendosi ad essa con il client della riga di comando, quindi svuotare tutte le tabelle e bloccare le istruzioni di scrittura eseguendo [`FLUSH TABLES WITH READ LOCK`]





>IMPORTANTE
>Lasciare in esecuzione [`FLUSH TABLES`] il client da cui è stata emessa l' istruzione in modo che il blocco di lettura rimanga attivo. Se si esce dal client, il blocco viene rilasciato.
```sql
mysql> FLUSH TABLES WITH READ LOCK;
```


In una sessione diversa sull'origine, utilizzare l'istruzione [`SHOW MASTER STATUS`] per determinare il nome e la posizione del file di registro binario corrente:

```sql
mysql > SHOW MASTER STATUS;
+------------------+----------+--------------+------------------+
| File             | Position | Binlog_Do_DB | Binlog_Ignore_DB |
+------------------+----------+--------------+------------------+
| mysql-bin.000003 | 73       | test         | manual,mysql     |
+------------------+----------+--------------+------------------+
```
