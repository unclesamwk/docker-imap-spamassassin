#!/bin/bash

touch /INIT

if [ $( ps axf | grep -c -E "[r]syslog" ) -eq 0 ] ; then
  /etc/init.d/rsyslog start
fi

if [ $( ps axf | grep -c -E "[s]pamd" ) -eq 0 ] ; then
  /etc/init.d/spamassassin start
fi

while true ; do

  if [ -f /INIT ]; then
    sa-learn --force-expire -D

    sa-update --nogpg --channel spamassassin.heinlein-support.de
    sa-update

    rm /INIT
  fi

  isbg \
    --teachonly \
    --imaphost="$MAILSERVER" \
    --imapuser="$MAILUSER" \
    --imappasswd="$MAILPASS" \
    --learnspambox="$LEARNINBOX" \
    --learnhambox="$LEARNHAMBOX" \
    --learnthendestroy \
    --noninteractive

  isbg \
    --flag \
    --imaphost="$MAILSERVER" \
    --imapuser="$MAILUSER" \
    --imappasswd="$MAILPASS" \
    --imapinbox="$IMAPINBOX" \
    --spaminbox="$SPAMINBOX" \
    --noninteractive

  sleep 60

done | tee -a /var/log/spam.log
