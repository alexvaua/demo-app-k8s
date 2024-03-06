#!/usr/bin/env bash

IMG="alexmedved/demo-app-k8s"
PAYLOAD="hello World"
APP="hw-demo-app"

publish() {
    docker login
    # docker build -t $IMG .
    docker tag demo-app-k8s_app $IMG
    docker push $IMG
}

deploy() {
    helm dependency update ./${APP}
    kubectl create ns ${APP}-ns
    helm install $APP ./${APP} -n ${APP}-ns
}

check() {
    kubectl get all -n ${APP}-ns
    sleep 10
    kubectl port-forward svc/${APP} 5000 &
    sleep 3
    echo -e "\n"
    curl -sS -X POST -d "$PAYLOAD" http://localhost:5000/set/1
    echo -e "\n"
    curl http://localhost:5000/get/1
    echo -e "\n"
}

clean() {
    helm delete ${APP}
    kubectl delete ns ${APP}-ns
    curl -sS -o /dev/null http://localhost:5000/get/1 >/dev/null 2>&1
    rm -rf ${APP}/charts/redis* ${APP}/Chart.lock
}

build() {
    docker-compose up --build -d; sleep 3
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
}

redis_running() {
    POD_NAME="${APP}-redis-master-0"

    INTERVAL=5
    echo "Watching pod $POD_NAME for Running status..."

    while true; do
        POD_READY=$(kubectl get pod $POD_NAME -n ${APP}-ns -o jsonpath="{.status.conditions[?(@.type=='Ready')].status}")

        if [ "$POD_READY" == "True" ]; then
            echo "Pod $POD_NAME is ready."
            break
        else
            echo "Pod $POD_NAME is not ready. Checking again in $INTERVAL seconds..."
        fi

        sleep $INTERVAL
    done
        check
        clean
}

build
deploy
redis_running
