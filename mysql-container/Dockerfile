# Dockerfile that modifies ringo/scientific to create a data volume container.
FROM scientificlinux/sl:6
LABEL Wim De Meester <deepskywim@gmail.com>
RUN mkdir -p /var/lib/mysql
VOLUME /var/lib/mysql
ENTRYPOINT /usr/bin/tail -f /dev/null
