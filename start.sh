#!/bin/bash

if [ $( ps axf | grep -c -E "[r]syslog" ) -eq 0 ] ; then
  /etc/init.d/rsyslog start
fi

if [ $( ps axf | grep -c -E "[s]pamd" ) -eq 0 ] ; then
  /etc/init.d/spamassassin start
fi

while true ; do

  if [ ! -f /INIT ] ; then

  isbg.py \
    --teachonly \
    --imaphost "$MAILSERVER" \
    --imapuser="$MAILUSER" \
    --learnspambox="$LEARNINBOX" \
    --learnthendestroy \
	  --noninteractive

  isbg.py \
    --flag \
    --imaphost "$MAILSERVER" \
	  --imapuser="$MAILUSER" \
	  --imapinbox="$IMAPINBOX" \
    --spaminbox="$SPAMINBOX" \
    --noninteractive

  else

    echo "Führen Sie vor dem Einsatz des Containers folgenden Befehl aus:"
    echo "isbg.py --verbose --imaphost ${MAILSERVER} --imapuser ${MAILUSER} --savepw && rm /INIT"

    sa-learn --force-expire -D

    sa-update --nogpg --channel spamassassin.heinlein-support.de
    sa-update

  fi

  sleep 60

done | tee -a /var/log/spam.log
