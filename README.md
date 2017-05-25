# docker-mysql

The `docker-mysql` image provides a Docker container running MySQL 5.5 
based on [mysql/mysql-server](https://hub.docker.com/r/mysql/mysql-server/) official image.

## Usage

Start a MySQL instance as follows:


    docker run --name my-container-name -e MYSQL_ROOT_PASSWORD=my-secret-pw -d jmmoreno/docker-mysql:5.5

... where my-container-name is the name you want to assign to your container, 
my-secret-pw is the password to be set for the MySQL root user and tag is the 
tag specifying the MySQL version you want. See the list above for relevant tags, 
or look at the full list of tags.

Once you have started a database container, you can then connect to the
database as follows:

    docker exec -it my-container-name mysql -uroot -p

## Configuration (environment variables)

When you start the MySQL image, you can adjust the configuration of the MySQL instance by 
passing one or more environment variables on the docker run command line. Do note that none 
of the variables below will have any effect if you start the container with a data directory 
that already contains a database: any pre-existing database will always be left untouched 
on container startup.

Most of the variables listed below are optional, but one of the variables MYSQL_ROOT_PASSWORD, 
MYSQL_ALLOW_EMPTY_PASSWORD, MYSQL_RANDOM_ROOT_PASSWORD must be given.

	MYSQL_ROOT_PASSWORD
	
This variable specifies a password that will be set for the MySQL root superuser account. 
In the above example, it was set to my-secret-pw. NOTE: Setting the MySQL root user 
password on the command line is insecure. See the section Secure Container Startup below for an alternative.

As an alternative to specifying the password explicitly, if the variable is set 
to a file path, the contents of the file will be used as the root password.

	MYSQL_RANDOM_ROOT_PASSWORD
	
When this variable is set to yes, a random password for the server's root user will be generated. 
The password will be printed to stdout in the container, and it can be obtained by using the 
command docker logs my-container-name.

	MYSQL_ONETIME_PASSWORD

This variable is optional. When set to yes, the root user's password will be set as expired, 
and must be changed before MySQL can be used normally. This is only supported by MySQL 5.6 or newer.

	MYSQL_DATABASE
	
This variable is optional. It allows you to specify the name of a database to be created 
on image startup. If a user/password was supplied (see below) then that user will be 
granted superuser access (corresponding to GRANT ALL) to this database.

	MYSQL_USER, MYSQL_PASSWORD
	
These variables are optional, used in conjunction to create a new user and set that user's password. 
This user will be granted superuser permissions (see above) for the database specified by 
the MYSQL_DATABASE variable. Both variables are required for a user to be created.

Do note that there is no need to use this mechanism to create the root superuser, that user gets 
created by default with the password set by either of the mechanisms (given or generated) discussed above.

	MYSQL_ALLOW_EMPTY_PASSWORD
	
Set to yes to allow the container to be started with a blank password for the root user. 
NOTE: Setting this variable to yes is not recommended unless you really know what you are doing, 
since this will leave your MySQL instance completely unprotected, allowing anyone to 
gain complete superuser access.

	MYSQL_ROOT_HOST
	
By default, MySQL creates the 'root'@'localhost' account. This account can only be connected to 
from inside the container, requiring the use of the docker exec command as noted under Connect to MySQL 
from the MySQL Command Line Client. To allow connections from other hosts, set this environment variable. 
As an example, the value "172.17.0.1", which is the default Docker gateway IP, will allow connections 
from the Docker host machine.

## Data persistence

If you want to make your data persistent, you need to mount a volume:

	docker run ....... -v /opt/db/mysql:/var/lib/mysql .....

in order to make sure that everything is restored after a restart of the container (databases, configuration, ...).

## Custom configuration file

If you want to use your own configuration file, you need to mount it into a volume:

	docker run ....... -v /opt/db/mysql/my.cnf:/etc/my.cnf .....
