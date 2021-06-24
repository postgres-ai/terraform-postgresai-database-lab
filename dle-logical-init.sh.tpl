#!/bin/bash

set -x

sleep 20
#run certbot and copy files to envoy
sudo certbot certonly --standalone -d demo-api-engine.aws.postgres.ai -m m@m.com --agree-tos -n
# to avoid restrinctions from letsencript like "There were too many requests of a given type :: Error creating new order :: too many certificates (5) already issued for this exact set of domains in the last 168 hours: demo-api-engine.aws.postgres.ai: see https://letsencrypt.org/docs/rate-limits/" follwing two lines were commented out and mocked up. In real implementation inline certs have to be removed and letsencrypt generated certs should be used
#sudo cp /etc/letsencrypt/archive/demo-api-engine.aws.postgres.ai/fullchain1.pem /etc/envoy/certs/
#sudo cp /etc/letsencrypt/archive/demo-api-engine.aws.postgres.ai/privkey1.pem /etc/envoy/certs/
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

#create zfs pools
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

#configure and start DLE
mkdir ~/.dblab 
cp /home/ubuntu/.dblab/config.example.logical_generic.yml ~/.dblab/server.yml
sed -ri "s/^(\s*)(debug:.*$)/\1debug: ${dle_debug}/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(timetable:.*$)/\1timetable: \"${dle_retrieval_refresh_timetable}\"/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(forceInit:.*$)/\1forceInit: true/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(verificationToken:.*$)/\1verificationToken: ${dle_token}/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(dbname:.*$)/\1dbname: ${postgres_source_dbname}/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(host: 34.56.78.90$)/\1host: ${postgres_source_host}/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(port: 5432$)/\1port: ${postgres_source_port}/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(            username: postgres$)/\1            username: ${postgres_source_username}/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(password:.*$)/\1password: ${postgres_source_password}/" ~/.dblab/server.yml
sed -ri "s/:13/:${postgres_source_version}/g"  ~/.dblab/server.yml
#restore pg_dump via pipe -  without saving it on the disk
sed -ri "s/^(\s*)(parallelJobs:.*$)/\1parallelJobs: 1/" ~/.dblab/server.yml
sed -ri "s/^(\s*)(# immediateRestore:.*$)/\1immediateRestore: /" ~/.dblab/server.yml
sed -ri "s/^(\s*)(#   forceInit: false.*$)/\1  forceInit: true /" ~/.dblab/server.yml
sed -ri "s/^(\s*)(- logicalRestore.*$)/\1#- logicalRestore /" ~/.dblab/server.yml


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
 postgresai/dblab-server:${dle_version_full}

### Waiting for the Database Lab Engine initialization.
for i in {1..30000}; do
  curl http://localhost:2345 > /dev/null 2>&1 && break || echo "dblab is not ready yet"
  sleep 10
done

dblab init \
 --environment-id=tutorial \
 --url=http://localhost:2345 \
 --token=_token_ \
 --insecure

#configure and run Joe Bot container
cp /home/ubuntu/joe.yml ~/.dblab/joe.yml
sed -ri "s/^(\s*)(debug:.*$)/\1debug: ${dle_debug}/" ~/.dblab/joe.yml
sed -ri "s/^(\s*)(  token:.*$)/\1  token: ${platform_token}/" ~/.dblab/joe.yml
sed -ri "s/^(\s*)(     token:.*$)/\1     token: ${dle_token}/" ~/.dblab/joe.yml
sed -ri "s/^(\s*)(    url:.*$)/\1    url: \"${dle_url}\"/" ~/.dblab/joe.yml
sed -ri "s/^(\s*)(dbname:.*$)/\1dbname: ${postgres_source_dbname}/" ~/.dblab/joe.yml
sed -ri "s/^(\s*)(signingSecret:.*$)/\1signingSecret: ${joe_signing_secret}/" ~/.dblab/joe.yml
sed -ri "s/^(\s*)(project:.*$)/\1project: ${platform_project_name}/" ~/.dblab/joe.yml

sudo docker run \
    --name joe_bot \
    --publish 2400:2400 \
    --restart=on-failure \
    --volume ~/.dblab/joe.yml:/home/config/config.yml \
    --detach \
postgresai/joe:latest
