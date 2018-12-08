使用本地存储。

执行脚本前，先创建命名空间：
```bash
kubectl create namespace rocketmq
kubectl label nodes kube04 node-role.kubernetes.io/rocketmq=true
kubectl label nodes kube05 node-role.kubernetes.io/rocketmq=true
```