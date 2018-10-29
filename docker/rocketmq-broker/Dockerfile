#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

FROM registry.cn-hangzhou.aliyuncs.com/szss/rocketmq-base:v4.3.1
#FROM szss/rocketmq-base:4.3.1

ENV BROKER_CLUSTER_NAME="RocketMQCluster"
ENV NAME_SRV_ADDR="rockermq-broker-0.rockermq-broker.rocketmq:9876,rockermq-broker-1.rockermq-broker.rocketmq:9876"
ENV BROKER_ID=0
ENV BROKER_ROLE="ASYNC_MASTER"
ENV POD_NAME=""
ENV STATEFULSET_NAME=""
ENV BROKER_NAME_PREFIX="broker"
ENV BROKER_NAME=""
#是否允许 Broker 自动创建Topic，建议线下开启，线上关闭
ENV AUTO_CREATE_TOPIC_ENABLE=false
#是否允许 Broker 自动创建订阅组，建议线下开启，线上关闭
ENV AUTO_CREATE_SUBSCRIPTION_GROUP=false
#删除文件时间点，默认凌晨 4点
ENV DELETE_WHEN=4
#文件保留时间，默认 48 小时
ENV FILE_RESERVED_TIME=120
#commitLog每个文件的大小默认1G
ENV MAPED_FILE_SIZE_COMMIT_LOG=1073741824
#ConsumeQueue每个文件默认存30W条，根据业务情况调整
ENV MAPED_FILE_SIZE_CONSUME_QUEUE=300000
#发送信息线程池线程个数
ENV SEND_MESSAGE_THREAD_POOL_NUMS=16
#拉取信息线程池线程个数
ENV PULL_MESSAGE_THREAD_POOL_NUMS=""

EXPOSE 10909 10911

RUN mv ${ROCKETMQ_HOME}/bin/runbroker-customize.sh ${ROCKETMQ_HOME}/bin/runbroker.sh \
 && chmod a+x ${ROCKETMQ_HOME}/bin/runbroker.sh \
 && chmod a+x ${ROCKETMQ_HOME}/bin/mqbroker


COPY scripts/ ${ROCKETMQ_HOME}/bin/

RUN chmod a+x ${ROCKETMQ_HOME}/bin/entrypoint.sh

ENTRYPOINT ${ROCKETMQ_HOME}/bin/entrypoint.sh