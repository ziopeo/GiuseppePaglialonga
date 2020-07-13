CLIENT (mysql -V mysql 5.7)
```
  $ ifconfig
  ```
Dedurre l'indirizzo ip del client e annotarlo


***
Andiamo sul
SERVER (mysql -V mysql8.0)

```
mysql -u studente -p

```

```
mysql -u studente -p
```
```
CREATE USER 'client'@'indirizzoipclient' IDENTIFIED WITH mysql_native_password BY 'passwordclient';
```
```
GRANT ALL PRIVILEGES ON *.* TO 'client'@'indirizzoipdelclient';
FLUSH PRIVILEGES;
exit
```

```
  $ ifconfig
```
Annotare l'indirizzo ip del server (10.10.11.x)

***

Andiamo sul
CLIENT (mysql -V mysql5.7)

Il nome utente "client" è quello che abbiamo creato nel servere a cui abbiamo dato privilegi di accesso
indirizzoipdelserver è in formato 10.10.11.x
```
mysql -u client -h indirizzoipdelserver -p

```
