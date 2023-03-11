FROM debian:latest

RUN apt update 2>/dev/null
RUN apt install -y git gitweb apache2 apache2-utils 2>/dev/null

COPY etc/git.conf /etc/apache2/sites-available/git.conf
RUN a2enmod env cgi alias rewrite
RUN a2dissite 000-default.conf
RUN a2ensite git.conf

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

ENV GIT_PROJECT_ROOT /git
RUN mkdir -p /git
RUN chown -Rfv www-data:www-data /git

COPY etc/git-create-repo.sh /usr/bin/mkrepo
RUN chmod +x /usr/bin/mkrepo

RUN git config --system http.receivepack true
RUN git config --system http.uploadpack true

CMD /usr/sbin/apache2ctl -D FOREGROUND

EXPOSE 80/tcp
VOLUME "/git"
