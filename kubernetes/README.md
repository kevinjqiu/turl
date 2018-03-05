Deployment with kubernetes
==========================

This folder contains supporting files for deploying turl on a kubernetes cluster.

Requirements
------------

Download and install:

* [minikube](https://github.com/kubernetes/minikube) - a local kubernetes cluster for development
* [helm](https://github.com/kubernetes/helm) - kubernetes package manager
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - kubernetes cli

Startup local cluster
---------------------

Startup the local cluster by:

    $ minikube start
    Starting local Kubernetes v1.9.0 cluster...
    Starting VM...
    Downloading Minikube ISO
     142.22 MB / 142.22 MB [============================================] 100.00% 0s
    Getting VM IP address...
    Moving files into cluster...
    Downloading localkube binary
     162.41 MB / 162.41 MB [============================================] 100.00% 0s
     0 B / 65 B [----------------------------------------------------------]   0.00%
     65 B / 65 B [======================================================] 100.00% 0sSetting up certs...
    Connecting to cluster...
    Setting up kubeconfig...
    Starting cluster components...
    Kubectl is now configured to use the cluster.
    Loading cached images from config file.

After this, your `kubectl` is setup to talk to the local minikube cluster.

Enable ingress:

    minikube addons enable ingress

This allows us to expose the turl service in the cluster and have it addressable by a domain name.

Install helm
------------

Helm is the package manager for kubernetes. It has a in-cluster server component that needs to be initiated first:

    $ helm init

Install postgresql
------------------

	$ helm install -f values/postgresql.yaml stable/postgresql --name turl-db
	NAME:   turl-db
	LAST DEPLOYED: Mon Mar  5 16:26:39 2018
	NAMESPACE: default
	STATUS: DEPLOYED

	RESOURCES:
	==> v1/Secret
	NAME                TYPE    DATA  AGE
	turl-db-postgresql  Opaque  1     0s

	==> v1/PersistentVolumeClaim
	NAME                STATUS  VOLUME                                    CAPACITY  ACCESSMODES  STORAGECLASS  AGE
	turl-db-postgresql  Bound   pvc-e4324afb-20bb-11e8-8f3c-0800275f4aea  8Gi       RWO          standard      0s

	==> v1/Service
	NAME                CLUSTER-IP    EXTERNAL-IP  PORT(S)   AGE
	turl-db-postgresql  10.106.45.86  <none>       5432/TCP  0s

	==> v1beta1/Deployment
	NAME                DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
	turl-db-postgresql  1        1        1           0          0s


	NOTES:
	PostgreSQL can be accessed via port 5432 on the following DNS name from within your cluster:
	turl-db-postgresql.default.svc.cluster.local

	To get your user password run:

		PGPASSWORD=$(kubectl get secret --namespace default turl-db-postgresql -o jsonpath="{.data.postgres-password}" | base64 --decode; echo)

	To connect to your database run the following command (using the env variable from above):

	   kubectl run --namespace default turl-db-postgresql-client --restart=Never --rm --tty -i --image postgres \
	   --env "PGPASSWORD=$PGPASSWORD" \
	   --command -- psql -U turl \
	   -h turl-db-postgresql turl_production



	To connect to your database directly from outside the K8s cluster:
		 PGHOST=127.0.0.1
		 PGPORT=5432

		 # Execute the following commands to route the connection:
		 export POD_NAME=$(kubectl get pods --namespace default -l "app=turl-db-postgresql" -o jsonpath="{.items[0].metadata.name}")
		 kubectl port-forward --namespace default $POD_NAME 5432:5432

Wait until the pod is ready:

    $ kubectl get pod
    NAME                                  READY     STATUS    RESTARTS   AGE
    turl-db-postgresql-57b5f9876f-5pbds   1/1       Running   0          1m

Install turl
------------

	$ helm install -f values/turl.yaml charts/turl/ --name turl
	NAME:   turl
	LAST DEPLOYED: Mon Mar  5 16:45:19 2018
	NAMESPACE: default
	STATUS: DEPLOYED

	RESOURCES:
	==> v1/Service
	NAME       CLUSTER-IP   EXTERNAL-IP  PORT(S)  AGE
	turl-turl  10.98.47.48  <none>       80/TCP   0s

	==> v1beta1/Deployment
	NAME       DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
	turl-turl  1        1        1           0          0s


	NOTES:
	1. Get the application URL by running these commands:
	  export POD_NAME=$(kubectl get pods --namespace default -l "app=turl,release=turl" -o jsonpath="{.items[0].metadata.name}")
	  echo "Visit http://127.0.0.1:8080 to use your application"
	  kubectl port-forward $POD_NAME 8080:80

Wait for the pod to be ready:

    $ kubectl get pod
    NAME                                  READY     STATUS        RESTARTS   AGE
    turl-db-postgresql-57b5f9876f-5pbds   1/1       Running       0          22m
    turl-turl-766b469787-5xmqb            1/1       Running       0          16s

You should also have an ingress resource created for you:

    $ kubectl get ingress
    NAME        HOSTS        ADDRESS          PORTS     AGE
    turl-turl   turl.local   192.168.99.100   80        7m

As you can see, the ip address is filled in. Since `turl.local` is not a real registered domain, we will have to add it to our hosts file:

    echo "192.168.99.100 turl.local alpha.turl.local beta.turl.local" | sudo -a tee /etc/hosts

Now, the turl service is addressable and reachable from outside of the cluster:

    $ curl -XPOST -H"Content-Type:application/json" http://alpha.turl.local/links -d'{"original": "http://google.com"}'
    {"original":"http://google.com","shortened":"http://alpha.turl.local/2sEC"}

    $ curl -I http://alpha.turl.local/2sEC
    HTTP/1.1 302 Found
    Server: nginx/1.13.7
    Date: Mon, 05 Mar 2018 22:02:31 GMT
    Content-Type: text/plain; charset=utf-8
    Connection: keep-alive
    Location: http://google.com
    Cache-Control: no-cache
    X-Request-Id: bdabde75-48c5-4fb5-9b0e-a8d6112ea762
    X-Runtime: 0.011443

Scale up
--------

One advantage of running the service in Kubernetes is that it's dead easy to scale up and down a stateless service (such as turl).

There are a couple of ways to do it but since we're using helm to manage our deployments, we should scale it using helm.

Open `values/turl.yaml` file, find `replicaCount` key and modify it to `5`.

Now upgrade the release using helm:

    $ helm upgrade turl -f values/turl.yaml charts/turl
    Release "turl" has been upgraded. Happy Helming!
    LAST DEPLOYED: Mon Mar  5 17:05:34 2018
    NAMESPACE: default
    STATUS: DEPLOYED

    RESOURCES:
    ==> v1/Service
    NAME       CLUSTER-IP   EXTERNAL-IP  PORT(S)  AGE
    turl-turl  10.98.47.48  <none>       80/TCP   20m

    ==> v1beta1/Deployment
    NAME       DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
    turl-turl  5        5        5           1          20m

    ==> v1beta1/Ingress
    NAME       HOSTS                                       ADDRESS         PORTS  AGE
    turl-turl  turl.local,alpha.turl.local,beta.tur.local  192.168.99.100  80     15m

Now we have 5 pods serving request:

    $ kubectl get pod
    NAME                                  READY     STATUS    RESTARTS   AGE
    turl-db-postgresql-57b5f9876f-5pbds   1/1       Running   0          39m
    turl-turl-766b469787-5xmqb            1/1       Running   0          17m
    turl-turl-766b469787-6qh84            1/1       Running   0          28s
    turl-turl-766b469787-fcgvg            1/1       Running   0          28s
    turl-turl-766b469787-jxz5k            1/1       Running   0          28s
    turl-turl-766b469787-xvq8v            1/1       Running   0          28s
