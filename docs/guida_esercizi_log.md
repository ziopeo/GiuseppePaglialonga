# Appunti lezione sui logs
```
binlog_ecryption 1 //crittografia 
```

```
log_bin //binary log - riavvio
```

```
sync_binlog=1
```

```
max_binlog_size //>nuovo binary log
```

```
binlog_cache_size// grandezza del buffer per le transazioni avviate da un thread
```

```
--log_bin
```

Assegnare path logbin a server spento
```
--log-bin-index[=filename]
```

Viene memorizzato in
```
log_bin_basename
```

```
binlog_cache_use // mostra il di transazioni che hanno utilizzato questo buffer(memorizzazione)
```

```
binlog_cache_disk_use //mostra quante transazione sono più grandi di max_binlog_cache_size
```
Dimensione totale per cache transazioni min 4096 bytes
Consigliato: 4GB IMPORTANTE
Predefinito e max: 16 exbibytes
```
max_binlog_cache_size
```

Registrazione binaria
```
sql_log_bin=OFF
```

Sintassi mysqlbinlog
```
shell> mysqlbinlog filelog | mysql -h localhost
```

Se il server non è in grado si scrivere nel binary log
```
binlog_error_action 
```


//Formati di registrazione del log binario //mysqld

STATEMENT: basata su istruzioni
ROW: basata su righe
MIXED: quando replica su diversi storage engine - all'occorrenza registra con ROW
```
--binlog-format=STATEMENT;
--binlog-format=ROW;
--binlog-format=MIXED;
```
SETTARE binlog_format a runtime - SERVER
```
mysql> SET GLOBAL binlog_format = 'STATEMENT';
mysql> SET GLOBAL binlog_format = 'ROW';
mysql> SET GLOBAL binlog_format = 'MIXED';
```

Settare a runtime da command CLIENT line il binlog_format
Registrazione binaria in base alla sessione
```
mysql> SET SESSION binlog_format = 'STATEMENT';
mysql> SET SESSION binlog_format = 'ROW';
mysql> SET SESSION binlog_format = 'MIXED';
mysql> SET @@SESSION.binlog_format; //se la sessione ha tabelle temporanee aperte , il formato non può essere modificato
```


Per disabilitare
```
--skip-log-bin
--disable-log-bin
```

Cancellare binary log files
```
RESET MASTER
PURGE BINARY LOGS //sottoinsieme
```
Stopping brusco registrazione binaria
```
ABORT_SERVER
```
### REPLICA
Richiedono la registrazione binaria attiva
```
--log-slave-updates = OFF //predefinita 1
--slave-preserve-commit-order
```

# LOG QUERY LENTE 
mysqldumpslow
1-10 secondi 
anche in microsecondi 
massimo tempo per essere considerata lenta
```
long_query_time 
```

```
min_examined_row_limit // righe da esaminare minime -non per quelle banali
log_slow_admin_statements //Per registrare anche istruzione che contengono comandi AMMINISTRATIVI
log_queries_not_using_indexes// ALTER TABLE, ANALYZE TABLE, CHECK TABLE, CREATE INDEX, DROP INDEX, OPTIMIZE TABLE, REPAIR TABLE
```

Comando per attivare all'avvio di mysqld LOG SLOW QUERY
Se non impostate un nome per lo SLOW QUERY LOG -->Data-Directory /var/lib/mysql/slow.log
```
--slow_query_log=1 // [={0|1}]
--slow_query_log //abilita comunque
```


Abilitare/disabilitare SLOW QUERY LOG
```
SET GLOBAL slow_query_log // [={0|1}]
```

```
slow_query_log_file // se vogliamo specificare il nome dello slow.log 
```
All'avvio di mysqld
```
--log-short-format


Se abilitiamo General Query Log senza indicare la posizione per il file di log, predefinito:
```
/var/lib/mysql/host_name.log //nome predefinito nella Data-Directory
```

```
general_log [={0|1}]
```

Avviare GENERAL QUERY LOGGING
```
SET GLOBAL general_log = "ON"
```

nome del file di GENERAL LOG // se impostate un file a runtime, memorizza il vecchio e crea il nuovo con il nome da voi indicato
```
general_log_file
```


```
