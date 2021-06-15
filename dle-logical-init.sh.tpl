#!/bin/bash

set -x

disks=(${dle_disks})
for i in $${!disks[@]}; do
  sudo zpool create -f \
  -O compression=on \
  -O atime=off \
  -O recordsize=128k \
  -O logbias=throughput \
  -m /var/lib/dblab/dblab_pool_0$i\
  dblab_pool_0$i \
  $${disks[$i]}
done

mkdir ~/.dblab
cp /home/ubuntu/.dblab/config.example.logical_generic.yml ~/.dblab/server.yml
sed -ri "s/^(\s*)(debug:.*$)/\1debug: ${dle_debug}/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(timetable:.*$)/\1timetable: \"${dle_timetable}\"/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(forceInit:.*$)/\1forceInit: true/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(verificationToken:.*$)/\1verificationToken: ${dle_token}/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(dbname:.*$)/\1dbname: ${postgres_source_dbname}/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(host: 34.56.78.90$)/\1host: ${postgres_source_host}/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(port: 5432$)/\1port: ${postgres_source_port}/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(            username: postgres$)/\1            username: ${postgres_source_username}/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(password:.*$)/\1password: ${postgres_source_password}/" ~/.dblab/server.yml
sed -ri "s/:13/:${postgres_source_version}/g"  ~/.dblab/server.yml

sudo docker run \
 --name dblab_server \
 --label dblab_control \
 --privileged \
 --publish 2345:2345 \
 --volume /var/run/docker.sock:/var/run/docker.sock \
 --volume /var/lib/dblab/dblab_pool_00/dump:/var/lib/dblab/dblab_pool/dump \
 --volume /var/lib/dblab:/var/lib/dblab/:rshared \
 --volume ~/.dblab/server.yml:/home/dblab/configs/config.yml \
 --env DOCKER_API_VERSION=1.39 \
 --detach \
 --restart on-failure \
 postgresai/dblab-server:${dle_version_short}-latest

### Waiting for the Database Lab Engine initialization.
for i in {1..300}; do
  curl http://localhost:2345 > /dev/null 2>&1 && break || echo "dblab is not ready yet"
  sleep 1
done

### Setup cert for SSH login
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot
sudo certbot certonly --standalone -d ${var.dns_api_subdomain}-engine

####################################################################
## This file should be written to:
## /etc/letsencrypt/renewal-hooks/deploy/postgresql.deploy
####################################################################
# #!/bin/bash
# umask 0177
# export DOMAIN=example.com
# export DATA_DIR=/var/lib/pgsql/data
# cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem $DATA_DIR/server.crt
# cp /etc/letsencrypt/live/$DOMAIN/privkey.pem   $DATA_DIR/server.key
# chown postgres:postgres  $DATA_DIR/server.crt $DATA_DIR/server.key

# Then make the above file executable so that certbot copies over new certs
# sudo chmod +x /etc/letsencrypt/renewal-hooks/deploy/postgresql.deploy

## change postgresql.conf to have:
# # - SSL -
# ssl = on
# ssl_cert_file = 'server.crt'
# ssl_key_file = 'server.key'
# ssl_prefer_server_ciphers = on

## change pg_hba.conf to have:
# hostssl    all    all    0.0.0.0/0    md5

dblab init \
 --environment-id=tutorial \
 --url=http://localhost:2345 \
 --token=_token_ \
 --insecure
