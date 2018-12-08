该脚本使用kubernetes的hostNetwork属性，是所有的pod使用宿主机IP，这样也支持集群外部的服务使用rocketmq。

rocketmq集群内部不能使用service访问，因为使用的宿主机的网络，但是kubernetes集群中的其他pod可以使用statefulset-rocketmq-namesrv-prod-0.service-rocketmq-namesrv-prod.rocketmq:9876;statefulset-rocketmq-namesrv-prod-1.service-rocketmq-namesrv-prod.rocketmq:9876访问rocketmq命名服务。

执行脚本前，先创建命名空间：
```bash
kubectl create namespace rocketmq
kubectl label nodes kube04 node-role.kubernetes.io/rocketmq=true
kubectl label nodes kube05 node-role.kubernetes.io/rocketmq=true
```