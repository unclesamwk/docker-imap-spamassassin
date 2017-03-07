#!/bin/bash

sa-learn --force-expire -D

sa-update --nogpg --channel spamassassin.heinlein-support.de
sa-update

/etc/init.d/rsyslog start
/etc/init.d/spamassassin start

while true ; do

  if [ ! -f /INIT ] ; then

  isbg.py \
        --imaphost "$MAILSERVER" \
        --imapuser="$MAILUSER" \
        --teachonly \
        --learnspambox="$LEARNINBOX" \
        --spamc

  isbg.py \
  	--imaphost "$MAILSERVER" \
	--imapuser="$MAILUSER" \
	--imapinbox="$IMAPINBOX" \
        --delete \
	--spamc \
	--verbose

  else

    echo "Führen Sie vor dem Einsatz des Containers folgenden Befehl aus:"
    echo "isbg.py --verbose --imaphost ${MAILSERVER} --imapuser ${MAILUSER} --savepw && rm /INIT"

  fi

  sleep 60

done | tee -a /var/log/spam.log



