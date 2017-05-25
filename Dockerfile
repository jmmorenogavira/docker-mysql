FROM		mysql/mysql-server:5.5
MAINTAINER	Jose Manuel Moreno Gavira  <josem.moreno.gavira@gmail.com>

COPY files/my.cnf	/etc/

# entrypoint is inherited from parent container
