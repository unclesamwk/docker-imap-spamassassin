# docker-imap-spamassassin

Dies ist ein Dockercontainer der für ein bestimmtes IMAP Postfach die SPAM - Prüfung durchführt.

### Container erstellen
`docker build . -t anyone/spamassasin`

### Start Container
`docker run -it -d -e MAILSERVER=${HOST} -e MAILUSER=${USER} -e IMAPINBOX=${IMAPINBOX} -e SPAMINBOX=${SPAMINBOX} -e LEARNINBOX=${LEARNINBOX} -e LEARNHAMBOX=${LERNHAMBOX} -e MAILPASS=${IMAPPASSWORD} --name docker-imap-spamassassin anyone/spamassasin`

### Prüfen der Container das tut was er soll
`docker logs -f docker-imap-spamassassin`

### Quellen
https://github.com/isbg/isbg
http://michael-heck.net/index.php/raspberry-pi/raspberry-pi-als-imap-spamfilter
