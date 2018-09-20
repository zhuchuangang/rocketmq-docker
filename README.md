# 1 打包docker镜像
```bash
docker build ./docker/rocketmq-base -t szss/rocketmq-base:4.3.1

docker build ./docker/rocketmq-broker -t szss/rocketmq-broker:4.3.1

docker build ./docker/rocketmq-namesrv -t szss/rocketmq-namesrv:4.3.1
```

# 3 创建namespace
```bash
kubectl create namespace rocketmq
```

# 4 节点打标签
```bash
kubectl label nodes kube-node node=rocketmq
```
> 注意：kube-node为节点名称,根据实际情况进行设置