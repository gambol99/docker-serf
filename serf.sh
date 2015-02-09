# Used in combination with config-fs (https://github.com/gambol99/config-fs)

etcdctl set /env/prod/setups/serf.sh '
#!/usr/bin/bash -x
#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-02-09 15:22:59 +0000 (Mon, 09 Feb 2015)
#
#  vim:ts=2:sw=2:et
#

if [ -f /env/prod/serf/serf.json ]; then
  etcdctl set /env/prod/serf/serf.json ""
fi
SERF_MEMBERS="`curl -s "localhost:4001/v1/machines" | sed -e "s/http:\/\///g" -e "s/^/-retry-join /g" -e "s/,/ -retry-join/g" -e "s/:4001//g"`"
echo "Serf Members: ${SERF_MEMBERS}"

SLEEP_TIME=${RANDOM:1:1}
echo "Sleep for ${SLEEP_TIME} seconds"
sleep $SLEEP_TIME

/usr/bin/docker run \
--name serf \
-e NAME=serf \
-e ENVIRONMENT=prod \
-e SERVICE_7946_NAME=serf \
-v /env/prod/serf/serf.json:/serf.json \
-p ${COREOS_PRIVATE_IPV4}:7946:7946/udp \
-p ${COREOS_PRIVATE_IPV4}:7946:7946 \
gambol99/serf agent -profile=lan -iface=eth0 -bind=0.0.0.0 -advertise=${COREOS_PRIVATE_IPV4} -log-level=info -config-file=serf.json ${SERF_MEMBERS}

'
