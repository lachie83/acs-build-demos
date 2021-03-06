#!/bin/bash
# Copyright 2016 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

. $(dirname ${BASH_SOURCE})/../util.sh

export HTTP=`yq .clusters[].cluster.server ~/.kube/config | grep build`
HTTP=${HTTP//\"}
export MASTER=${HTTP:8}

IP=$(kubectl --namespace=demos get svc deployment-demo \
        -o go-template='{{.spec.clusterIP}}')

run "ssh azureuser@${MASTER} '\
    while true; do \
        curl --connect-timeout 1 -s $IP; \
        sleep 0.5; \
    done'"
