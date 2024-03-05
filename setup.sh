#!/usr/bin/env bash

IMG="alexmedved/demo-app-k8s"
PAYLOAD="Hello World"

publish() {
    docker login
    # docker build -t $IMG .
    docker tag demo-app-k8s_app $IMG
    docker push $IMG
}

docker-compose up --build -d; sleep 2
curl -sS -X POST -d "$PAYLOAD" http://localhost:5000/set/1
test=$(curl -sS http://localhost:5000/get/1)
if [ "$test" = "$PAYLOAD" ]; then
    echo -e "\nTest succeeded, publishing to ${IMG}"
    docker-compose down
    publish
else
    echo "Test failed with payload: ${PAYLOAD}, received: ${test}"
    docker-compose down
fi

