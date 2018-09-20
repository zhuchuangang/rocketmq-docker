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

#FROM registry.cn-hangzhou.aliyuncs.com/szss/rocketmq-base:4.3.1
FROM szss/rocketmq-base:4.3.1

ENV NAME_SRV_ADDR="rockermq-broker-0.rockermq-broker.rocketmq:9876,rockermq-broker-1.rockermq-broker.rocketmq:9876"
ENV BROKER_ID=0
ENV BROKER_ROLE="ASYNC_MASTER"
ENV BROKER_NAME="broker-a"

EXPOSE 10909 10911

RUN mv ${ROCKETMQ_HOME}/bin/runbroker-customize.sh ${ROCKETMQ_HOME}/bin/runbroker.sh \
 && chmod a+x ${ROCKETMQ_HOME}/bin/runbroker.sh \
 && chmod a+x ${ROCKETMQ_HOME}/bin/mqbroker


COPY scripts/ ${ROCKETMQ_HOME}/bin/

ENTRYPOINT ${ROCKETMQ_HOME}/bin/entrypoint.sh

CMD export JAVA_OPT=" -Duser.home=/opt" \
 && sh ${ROCKETMQ_HOME}/bin/mqbroker -c ${ROCKETMQ_HOME}/conf/broker.conf