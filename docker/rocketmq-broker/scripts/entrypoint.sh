#!/bin/bash

cat > ${ROCKETMQ_HOME}/conf/broker.conf <<EOF
#集群名称
brokerClusterName=RocketMQCluster
#broker名称
brokerName=${BROKER_NAME}
#0 表示Master,>0 表示Slave
brokerId=${BROKER_ID}
#broker角色 ASYNC_MASTER为异步主节点，SYNC_MASTER为同步主节点，SLAVE为从节点
brokerRole=${BROKER_ROLE}
#刷新数据到磁盘的方式，ASYNC_FLUSH刷新
flushDiskType=ASYNC_FLUSH
##Broker 对外服务的监听端口
listenPort=10911
#nameserver地址，分号分割
namesrvAddr=${NAME_SRV_ADDR}
#在发送消息时，自动创建服务器不存在的topic，默认创建的队列数
defaultTopicQueueNums=4
#是否允许 Broker 自动创建Topic，建议线下开启，线上关闭
autoCreateTopicEnable=true
#是否允许 Broker 自动创建订阅组，建议线下开启，线上关闭
autoCreateSubscriptionGroup=true
#默认不配置brokerIP1和brokerIP2时，都会根据当前网卡选择一个IP使用，当你的机器有多块网卡时，很有可能会有问题。
#brokerIP1=10.100.50.111
#存储路径
storePathRootDir=/opt/rocketmq-${ROCKETMQ_VERSION}/data/store
#commitLog 存储路径
storePathCommitLog=/opt/rocketmq-${ROCKETMQ_VERSION}/data/store/commitlog
#消费队列存储路径存储路径
storePathConsumerQueue=/opt/rocketmq-${ROCKETMQ_VERSION}/data/store/consumequeue
#消息索引存储路径
storePathIndex=/opt/rocketmq-${ROCKETMQ_VERSION}/data/store/index
#checkpoint 文件存储路径
storeCheckpoint=/opt/rocketmq-${ROCKETMQ_VERSION}/data/store/checkpoint
#abort 文件存储路径
abortFile=/opt/rocketmq-${ROCKETMQ_VERSION}/data/store/abort
#删除文件时间点，默认凌晨 4点
deleteWhen=04
#文件保留时间，默认 48 小时
fileReservedTime=120
# commitLog每个文件的大小默认1G
mapedFileSizeCommitLog=1073741824
#ConsumeQueue每个文件默认存30W条，根据业务情况调整
mapedFileSizeConsumeQueue=300000
#destroyMapedFileIntervalForcibly=120000
#redeleteHangedFileInterval=120000
#检测物理文件磁盘空间
#diskMaxUsedSpaceRatio=88
EOF

cd ${ROCKETMQ_HOME}/bin \
 && export JAVA_OPT=" -Duser.home=/opt" \
 && sh mqbroker -c ../conf/broker.conf