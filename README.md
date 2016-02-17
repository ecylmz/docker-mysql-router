# mysql-router with docker

If you want to use this image for routing MySQL Master-Slave Replication, you must set `REPLICATION=true` environment
variable.

Our docker-entrypoint.sh script will search linked containers which are names start with `mysql_master` and `mysql-slave`.

For example: [mysql-master-slave](examples/mysql-master-slave)
Just run this command in `mysql-master-slave` directory

```sh
$ docker-compose up
```
