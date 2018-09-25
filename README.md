# 1 打包docker镜像
```bash
docker build ./docker/rocketmq-base -t szss/rocketmq-base:v4.3.1

docker build ./docker/rocketmq-broker -t szss/rocketmq-broker:v4.3.1

docker build ./docker/rocketmq-namesrv -t szss/rocketmq-namesrv:v4.3.1
```
如果直接使用阿里云镜像，此步骤可以忽略。

# 2 创建namespace
```bash
kubectl create namespace rocketmq
```

# 3 节点打标签
```bash
kubectl label nodes kube-node node=rocketmq
```
> 注意：kube-node为节点名称,根据实际情况进行设置


# 4 启动namesrv
```bash
kubectl create -f ./rocketmq-namesrv.yaml
```
rocketmq的命名服务使用statefulset进行部署，这样每个pod都有唯一的dns地址(对应的服务将没有cluster ip)，方便broker和消息producer服务调用。

# 5 启动broker主节点
```bash
kubectl create -f ./rocketmq-broker-master.yaml
```
rocketmq的broker服务使用statefulset进行部署，statefulset生成的pod名称中包含pod的序号，我们使用这个序号来生成broker的名称，这样broker的从节点可以和主节点匹配起来，
帮助完成集群的搭建。

```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  namespace: rocketmq
  name: configmap-rocketmq-broker-master-prod
data:
  # rocketmq命名服务地址
  NAME_SRV_ADDR: "statefulset-rocketmq-namesrv-prod-0.service-rocketmq-namesrv-prod.rocketmq:9876;statefulset-rocketmq-namesrv-prod-1.service-rocketmq-namesrv-prod.rocketmq:9876"
  # 主节点，这是broker_id为0
  BROKER_ID: "0"
  # 设置broker的角色为ASYNC_MASTER
  BROKER_ROLE: "ASYNC_MASTER"
  # STATEFULSET_NAME的名称设置，需要和statefulset对象的名称一致
  STATEFULSET_NAME: "statefulset-rocketmq-broker-master-prod"
```

在statefulset的env中，设置环境变量POD_NAME
```yaml
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
```

举个例子：STATEFULSET_NAME="statefulset-rocketmq-broker-master-prod"和POD_NAME="statefulset-rocketmq-broker-master-prod-0"，
而STATEFULSET_NAME和POD_NAME就差"-0"字符，在rocketmq-broker的entrypoint.sh脚本中，有如下代码，就是用来配置BROKER_NAME。
```bash
if [ ${POD_NAME} != "" ]; then
    POD_NUMBER=${POD_NAME#*${STATEFULSET_NAME}'-'}
    BROKER_NAME=${BROKER_NAME_PREFIX}'-'${POD_NUMBER}
fi

```
BROKER_NAME_PREFIX默认值设置为"broker"，所有最后我们得到BROKER_NAME为broker-0。

# 6 启动broker从节点
```bash
kubectl create -f ./rocketmq-broker-slave.yaml
```
从节点使用和主节点相同的镜像，只是配置稍有不同。
```yaml
kind: ConfigMap
apiVersion: v1
metadata:
  namespace: rocketmq
  name: configmap-rocketmq-broker-slave-prod
data:
  # rocketmq命名服务地址
  NAME_SRV_ADDR: "statefulset-rocketmq-namesrv-prod-0.service-rocketmq-namesrv-prod.rocketmq:9876;statefulset-rocketmq-namesrv-prod-1.service-rocketmq-namesrv-prod.rocketmq:9876"
  # 从节点，这是broker_id为非0的数字
  BROKER_ID: "1"
  # 设置broker的角色为SLAVE
  BROKER_ROLE: "SLAVE"
  # STATEFULSET_NAME的名称设置，需要和statefulset对象的名称一致  
  STATEFULSET_NAME: "statefulset-rocketmq-broker-slave-prod"
```


在statefulset的env中，设置环境变量POD_NAME
```yaml
        env:
        - name: POD_NAME
          valueFrom:
            fieldRef:
              fieldPath: metadata.name
```
