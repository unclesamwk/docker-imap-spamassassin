FROM ubuntu:14.04
MAINTAINER Samuel Warkentin <s.warkentin@mittwald.de>

# no need for confirmation
ENV DEBIAN_FRONTEND noninteractive

# Recommends are as of now still abused in many packages
#RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/no-recommends
#RUN echo "APT::Get::Assume-Yes "true";" > /etc/apt/apt.conf.d/always-yes

# ...put your own build instructions here...
RUN apt-get -qq update
RUN apt-get -y install spamassassin imapfilter python razor pyzor unp python-pip python-setuptools wget unzip rsyslog git
RUN pip install --upgrade pip && pip install setuptools docopt==0.6.2
RUN cd /bin/ && wget http://michael-heck.net/downloads/isbg.zip && unp isbg.zip && rm isbg.zip && chmod +x isbg.py
RUN cd root && mkdir .spamassassin 
#&& git clone https://github.com/isbg/isbg.git
ADD user_prefs /root/.spamassassin/user_prefs
ADD default_spamassassin /etc/default/spamassassin
ADD start.sh /start.sh
ADD cron_spamassassin /etc/cron.daily/spamassassin

# Clean up APT when done.
RUN apt-get autoremove --purge
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN touch /INIT

CMD cron && bash /start.sh
