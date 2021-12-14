#!/bin/bash

set -x

sleep 20
#run certbot and copy files to envoy
# to avoid restrictions from letsencrypt like "There were too many requests of a given type ::
# Error creating new order :: too many certificates (5) already issued for this exact set of domains
# in the last 168 hours: demo-api-engine.aws.postgres.ai: see https://letsencrypt.org/docs/rate-limits/"
# following three lines were commented out and mocked up. In real implementation inline certs have to be
# removed and letsencrypt generated certs should be used


# <START certbot generated cert>
#
#sudo certbot certonly --standalone -d ${aws_deploy_dns_api_subdomain}.${aws_deploy_dns_zone_name} -m ${aws_deploy_certificate_email} --agree-tos -n
#sudo cp /etc/letsencrypt/live/${aws_deploy_dns_api_subdomain}.${aws_deploy_dns_zone_name}/fullchain.pem /etc/envoy/certs/fullchain1.pem
#sudo cp /etc/letsencrypt/live/${aws_deploy_dns_api_subdomain}.${aws_deploy_dns_zone_name}/privkey.pem /etc/envoy/certs/privkey1.pem

# cat <<EOF > /etc/letsencrypt/renewal-hooks/deploy/envoy.deploy
# #!/bin/bash
# umask 0177
# export DOMAIN=${aws_deploy_dns_api_subdomain}.${aws_deploy_dns_zone_name}
# export DATA_DIR=/etc/envoy/certs/
# cp /etc/letsencrypt/live/$DOMAIN/fullchain.pem $DATA_DIR/fullchain1.pem
# cp /etc/letsencrypt/live/$DOMAIN/privkey.pem   $DATA_DIR/privkey1.pem
# EOF
# sudo chmod +x /etc/letsencrypt/renewal-hooks/deploy/envoy.deploy
#
# # <END certbot generated cert>
#
# FIXME
# 1. Write script to edit the `/etc/envoy/envoy.yaml` file so that it replaces the wildcard domains with specific domain


cat <<EOF > /etc/envoy/certs/fullchain1.pem
-----BEGIN CERTIFICATE-----
MIICqDCCAZACCQCquzpHNpqBcDANBgkqhkiG9w0BAQsFADAWMRQwEgYDVQQDDAtm
cm9udC1lbnZveTAeFw0yMDA3MDgwMTMxNDZaFw0zMDA3MDYwMTMxNDZaMBYxFDAS
BgNVBAMMC2Zyb250LWVudm95MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAthnYkqVQBX+Wg7aQWyCCb87hBce1hAFhbRM8Y9dQTqxoMXZiA2n8G089hUou
oQpEdJgitXVS6YMFPFUUWfwcqxYAynLK4X5im26Yfa1eO8La8sZUS+4Bjao1gF5/
VJxSEo2yZ7fFBo8M4E44ZehIIocipCRS+YZehFs6dmHoq/MGvh2eAHIa+O9xssPt
ofFcQMR8rwBHVbKy484O10tNCouX4yUkyQXqCRy6HRu7kSjOjNKSGtjfG+h5M8bh
10W7ZrsJ1hWhzBulSaMZaUY3vh5ngpws1JATQVSK1Jm/dmMRciwlTK7KfzgxHlSX
58ENpS7yPTISkEICcLbXkkKGEQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQCmj6Hg
vwOxWz0xu+6fSfRL6PGJUGq6wghCfUvjfwZ7zppDUqU47fk+yqPIOzuGZMdAqi7N
v1DXkeO4A3hnMD22Rlqt25vfogAaZVToBeQxCPd/ALBLFrvLUFYuSlS3zXSBpQqQ
Ny2IKFYsMllz5RSROONHBjaJOn5OwqenJ91MPmTAG7ujXKN6INSBM0PjX9Jy4Xb9
zT+I85jRDQHnTFce1WICBDCYidTIvJtdSSokGSuy4/xyxAAc/BpZAfOjBQ4G1QRe
9XwOi790LyNUYFJVyeOvNJwveloWuPLHb9idmY5YABwikUY6QNcXwyHTbRCkPB2I
m+/R4XnmL4cKQ+5Z
-----END CERTIFICATE-----
EOF
cat <<EOF > /etc/envoy/certs/privkey1.pem
-----BEGIN PRIVATE KEY-----
MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC2GdiSpVAFf5aD
tpBbIIJvzuEFx7WEAWFtEzxj11BOrGgxdmIDafwbTz2FSi6hCkR0mCK1dVLpgwU8
VRRZ/ByrFgDKcsrhfmKbbph9rV47wtryxlRL7gGNqjWAXn9UnFISjbJnt8UGjwzg
Tjhl6EgihyKkJFL5hl6EWzp2Yeir8wa+HZ4Achr473Gyw+2h8VxAxHyvAEdVsrLj
zg7XS00Ki5fjJSTJBeoJHLodG7uRKM6M0pIa2N8b6HkzxuHXRbtmuwnWFaHMG6VJ
oxlpRje+HmeCnCzUkBNBVIrUmb92YxFyLCVMrsp/ODEeVJfnwQ2lLvI9MhKQQgJw
tteSQoYRAgMBAAECggEAeDGdEkYNCGQLe8pvg8Z0ccoSGpeTxpqGrNEKhjfi6NrB
NwyVav10iq4FxEmPd3nobzDPkAftfvWc6hKaCT7vyTkPspCMOsQJ39/ixOk+jqFx
lNa1YxyoZ9IV2DIHR1iaj2Z5gB367PZUoGTgstrbafbaNY9IOSyojCIO935ubbcx
DWwL24XAf51ez6sXnI8V5tXmrFlNXhbhJdH8iIxNyM45HrnlUlOk0lCK4gmLJjy9
10IS2H2Wh3M5zsTpihH1JvM56oAH1ahrhMXs/rVFXXkg50yD1KV+HQiEbglYKUxO
eMYtfaY9i2CuLwhDnWp3oxP3HfgQQhD09OEN3e0IlQKBgQDZ/3poG9TiMZSjfKqL
xnCABMXGVQsfFWNC8THoW6RRx5Rqi8q08yJrmhCu32YKvccsOljDQJQQJdQO1g09
e/adJmCnTrqxNtjPkX9txV23Lp6Ak7emjiQ5ICu7iWxrcO3zf7hmKtj7z+av8sjO
mDI7NkX5vnlE74nztBEjp3eC0wKBgQDV2GeJV028RW3b/QyP3Gwmax2+cKLR9PKR
nJnmO5bxAT0nQ3xuJEAqMIss/Rfb/macWc2N/6CWJCRT6a2vgy6xBW+bqG6RdQMB
xEZXFZl+sSKhXPkc5Wjb4lQ14YWyRPrTjMlwez3k4UolIJhJmwl+D7OkMRrOUERO
EtUvc7odCwKBgBi+nhdZKWXveM7B5N3uzXBKmmRz3MpPdC/yDtcwJ8u8msUpTv4R
JxQNrd0bsIqBli0YBmFLYEMg+BwjAee7vXeDFq+HCTv6XMva2RsNryCO4yD3I359
XfE6DJzB8ZOUgv4Dvluie3TB2Y6ZQV/p+LGt7G13yG4hvofyJYvlg3RPAoGAcjDg
+OH5zLN2eqah8qBN0CYa9/rFt0AJ19+7/smLTJ7QvQq4g0gwS1couplcCEnNGWiK
72y1n/ckvvplmPeAE19HveMvR9UoCeV5ej86fACy8V/oVpnaaLBvL2aCMjPLjPP9
DWeCIZp8MV86cvOrGfngf6kJG2qZTueXl4NAuwkCgYEArKkhlZVXjwBoVvtHYmN2
o+F6cGMlRJTLhNc391WApsgDZfTZSdeJsBsvvzS/Nc0burrufJg0wYioTlpReSy4
ohhtprnQQAddfjHP7rh2LGt+irFzhdXXQ1ybGaGM9D764KUNCXLuwdly0vzXU4HU
q5sGxGrC1RECGB5Zwx2S2ZY=
-----END PRIVATE KEY-----
EOF

sudo systemctl enable envoy
sudo systemctl start envoy

# create zfs pools
# Get the full list of disks available and then make attempts
# to create zpool on each. Here we assume that the system disk
# will be skipped because it already has a filesystem.
# This is a "brute force" approach that we probably want to
# rework, but for now we leave it as is because it seems that 
# `/dev/../by-id` doesn't really work for all EC2 types.

disks=$(lsblk -ndp -e7 --output NAME)   # TODO: this is not needed, used now for debug only

i=1

sleep 10 # Not elegant at all, we need a better way to wait till the moment when all disks are available

# Show all disks in alphabetic order; "-e7" to exclude loop devices
for disk in $disks; do
  sudo zpool create -f \
    -O compression=on \
    -O atime=off \
    -O recordsize=128k \
    -O logbias=throughput \
    -m /var/lib/dblab/dblab_pool_$(printf "%02d" $i)\
    dblab_pool_$(printf "%02d" $i) \
    $disk \
    && ((i=i+1)) # increment if succeeded
done

# Adjust DLE config
dle_config_path="/home/ubuntu/.dblab/engine/configs"
dle_meta_path="/home/ubuntu/.dblab/engine/meta"
postgres_conf_path="/home/ubuntu/.dblab/postgres_conf"

mkdir -p $dle_config_path
mkdir -p $dle_meta_path
mkdir -p $postgres_conf_path

curl https://gitlab.com/postgres-ai/database-lab/-/raw/${dle_version}/configs/config.example.logical_generic.yml --output $dle_config_path/server.yml
curl https://gitlab.com/postgres-ai/database-lab/-/raw/${dle_version}/configs/standard/postgres/control/pg_hba.conf \
  --output $postgres_conf_path/pg_hba.conf
curl https://gitlab.com/postgres-ai/database-lab/-/raw/${dle_version}/configs/standard/postgres/control/postgresql.conf --output $postgres_conf_path/postgresql.conf
cat /tmp/postgresql_clones_custom.conf >> $postgres_conf_path/postgresql.conf

yq e -i '
  .global.debug=${dle_debug_mode} |
  .server.verificationToken="${dle_verification_token}" |
  .retrieval.refresh.timetable="${dle_retrieval_refresh_timetable}" |
  .retrieval.spec.logicalDump.options.source.connection.dbname="${source_postgres_dbname}" |
  .retrieval.spec.logicalRestore.options.forceInit=true |
  .databaseContainer.dockerImage="postgresai/extended-postgres:${source_postgres_version}"
' $dle_config_path/server.yml

# Enable Platform
yq e -i '
  .platform.url = "https://postgres.ai/api/general" |
  .platform.accessToken = "${platform_access_token}" |
  .platform.enablePersonalTokens = true |
' $dle_config_path/server.yml

case "${source_type}" in 

  postgres)
  # Mount directory to store dump files.
  extra_mount="--volume /var/lib/dblab/dblab_pool_00/dump:/var/lib/dblab/dblab_pool/dump"

  yq e -i '
    .retrieval.spec.logicalDump.options.source.connection.host = "${source_postgres_host}" |
    .retrieval.spec.logicalDump.options.source.connection.port = ${source_postgres_port} |
    .retrieval.spec.logicalDump.options.source.connection.username = "${source_postgres_username}" |
    .retrieval.spec.logicalDump.options.source.connection.password = "${source_postgres_password}" |
    .retrieval.spec.logicalDump.options.parallelJobs = 1
  ' $dle_config_path/server.yml

  # restore pg_dump via pipe -  without saving it on the disk
  yq e -i '
    .databaseContainer.dockerImage="postgresai/extended-postgres:${source_postgres_version}" |
    .retrieval.spec.logicalDump.options.immediateRestore.enabled=true |
    .retrieval.spec.logicalDump.options.immediateRestore.forceInit=true |
    .retrieval.spec.logicalDump.options.immediateRestore.configs alias = .databaseConfig |
    del(.retrieval.jobs[] | select(. == "logicalRestore")) |
    .databaseConfigs.configs.shared_preload_libraries = "${postgres_config_shared_preload_libraries}"
  ' $dle_config_path/server.yml
  ;;

  s3)
  # Mount S3 bucket if it's defined in Terraform variables
  mkdir -p "${source_pgdump_s3_mount_point}"
  s3fs ${source_pgdump_s3_bucket} ${source_pgdump_s3_mount_point} -o iam_role -o allow_other
  
  extra_mount="--volume ${source_pgdump_s3_mount_point}:${source_pgdump_s3_mount_point}"

  yq e -i '
    del(.retrieval.jobs[] | select(. == "logicalDump")) |
    .retrieval.spec.logicalRestore.options.dumpLocation="${source_pgdump_s3_mount_point}/${source_pgdump_path_on_s3_bucket}"
  ' $dle_config_path/server.yml

  nProcessors=$(getconf _NPROCESSORS_ONLN)
  yq e -i '
    .retrieval.spec.logicalDump.options.parallelJobs=${postgres_dump_parallel_jobs} |
    .retrieval.spec.logicalRestore.options.parallelJobs=$nProcessors
  ' $dle_config_path/server.yml
  ;;

esac

# Fix ownership of the dblab directory
chown -R ubuntu.ubuntu /home/ubuntu/.dblab/

sudo docker run \
  --name dblab_server \
  --label dblab_control \
  --privileged \
  --publish 2345:2345 \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume /var/lib/dblab:/var/lib/dblab/:rshared \
  --volume $dle_config_path:/home/dblab/configs:ro \
  --volume $dle_meta_path:/home/dblab/meta \
  --volume $postgres_conf_path:/home/dblab/standard/postgres/control \
  $extra_mount \
  --env DOCKER_API_VERSION=1.39 \
  --detach \
  --restart on-failure \
registry.gitlab.com/postgres-ai/database-lab/dblab-server:${dle_version}

### Waiting for the Database Lab Engine initialization.
for i in {1..30000}; do
  curl http://localhost:2345 > /dev/null 2>&1 && break || echo "dblab is not ready yet"
  sleep 10
done

curl https://gitlab.com/postgres-ai/database-lab/-/raw/${dle_version}/scripts/cli_install.sh | bash
sudo mv ~/.dblab/dblab /usr/local/bin/dblab

# Init dblab environment
dblab init \
 --environment-id=tutorial \
 --url=http://localhost:2345 \
 --token=${dle_verification_token} \
 --insecure

# Configure and run Joe Bot container.
joe_config_path="/home/ubuntu/.dblab/joe/configs"
joe_meta_path="/home/ubuntu/.dblab/joe/meta"

mkdir -p $joe_config_path
mkdir -p $joe_meta_path

curl https://gitlab.com/postgres-ai/joe/-/raw/${joe_version}/configs/config.example.yml --output $joe_config_path/joe.yml

yq e -i '
  .app.debug = ${dle_debug_mode} |
  .platform.token = "${platform_access_token}" |
  .channelMapping.dblabServers.prod1.token = "${dle_verification_token}" |
  .channelMapping.dblabServers.prod1.url = "http://localhost:2345" |
  .channelMapping.communicationTypes.webui[0].credentials.signingSecret = "${platform_joe_signing_secret}" |
  .channelMapping.communicationTypes.webui[0].channels[0].project = "${platform_project_name}" |
  .channelMapping.communicationTypes.webui[0].channels[0].dblabParams.dbname = "${source_postgres_dbname}" |
  del(.channelMapping.communicationTypes.slack) |
  del(.channelMapping.communicationTypes.slackrtm) |
  del(.channelMapping.communicationTypes.slacksm)
' $joe_config_path/joe.yml

sudo docker run \
  --name joe_bot \
  --network=host \
  --restart=on-failure \
  --volume $joe_config_path:/home/configs:ro \
  --volume $joe_meta_path:/home/meta \
  --detach \
  registry.gitlab.com/postgres-ai/joe:${joe_version}

# Configure and run DB Migration Checker.
ci_checker_config_path="/home/ubuntu/.dblab/ci_checker/configs"
mkdir -p $ci_checker_config_path

curl https://gitlab.com/postgres-ai/database-lab/-/raw/${dle_version}/configs/config.example.ci_checker.yml --output $ci_checker_config_path/ci_checker.yml

yq e -i '
  .app.debug = ${dle_debug_mode} |
  .app.verificationToken = "${vcs_db_migration_checker_verification_token}" |
  .dle.url = "http://dblab_server:2345" |
  .dle.verificationToken = "${dle_verification_token}" |
  .platform.accessToken = "${platform_access_token}" |
  .source.token = "${vcs_github_secret_token}"
' $ci_checker_config_path/ci_checker.yml

sudo docker run \
  --name dblab_ci_checker \
  --label dblab_control \
  --detach \
  --restart on-failure \
  --publish 2500:2500 \
  --volume /var/run/docker.sock:/var/run/docker.sock \
  --volume /tmp/ci_checker:/tmp/ci_checker \
  --volume $ci_checker_config_path:/home/dblab/configs:ro \
registry.gitlab.com/postgres-ai/database-lab/dblab-ci-checker:${dle_version}

