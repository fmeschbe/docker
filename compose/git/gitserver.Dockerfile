FROM debian:latest

RUN apt-get update -y && \
  apt-get install -y git gitweb apache2 apache2-utils

COPY etc/git.conf /etc/apache2/sites-available/git.conf
COPY etc/git-create-repo.sh /usr/bin/mkrepo

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV GIT_PROJECT_ROOT /var/lib/git

RUN a2enmod env cgi alias rewrite && \
  a2dissite 000-default.conf && \
  a2ensite git.conf && \
  mkdir -p /var/lib/git && \
  chown -Rfv www-data:www-data /var/lib/git && \
  git config --system http.receivepack true && \
  git config --system http.uploadpack true && \
  git config --system init.defaultBranch main

CMD /usr/sbin/apache2ctl -D FOREGROUND

EXPOSE 80/tcp
VOLUME "/var/lib/git"
