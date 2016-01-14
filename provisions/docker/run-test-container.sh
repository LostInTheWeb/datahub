#!/bin/bash

echo "Starting phantomjs container..."
if ! `docker inspect -f {{.State.Running}} phantomjs`; then
    (set -x; docker start phantomjs)
    echo "phantomjs started."
else
    echo "phantomjs already running. Skipping."
fi
echo "Stopping app container..."
(set -x; docker stop app)
echo "Spinning up test app container..."
echo "*** Run unit tests with 'sh /datahub/provisions/docker/run-unit-tests.sh'."
echo "*** Run functional tests with 'sh /datahub/provisions/docker/run-functional-tests.sh'."
echo "*** Run specific tests with commands like 'python manage.py test core'."
echo "*** Run a debuggable server with 'python manage.py runserver 0.0.0.0:8000'."
(set -x; docker run -ti --rm \
    -e "DATAHUB_DOCKER_TESTING=true" \
    -e "DJANGO_LIVE_TEST_SERVER_ADDRESS=0.0.0.0:8000" \
    --volumes-from logs \
    --volumes-from data \
    --net=datahub_dev \
    -v /vagrant:/datahub \
    -w /datahub/src \
    datahuborg/datahub /bin/bash)
echo "Bringing back app container..."
(set -x; docker start app)
