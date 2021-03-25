#!/usr/bin/env bash
set -ex

B64_CLUSTER_CA='${clusterCaCertificate}'

CLUSTERNAME='${clusterName}'

API_SERVER_URL='${clusterEndpoint}'

KUBEEXTRAARGS='${kubelet_extra_args}'

BOOTEXTRAARGS='${bootExtraArgs}'

K8S_CLUSTER_DNS_IP='${clusterDnsIpAddress}'

# mkdir -p /etc/cni/net.d 2>>/dev/null
# chmod 777 /etc/cni 2>>/dev/null
# chmod 777 /etc/cni/net.d 2>>/dev/null
# touch /etc/cni/net.d/10-aws.conflist 2>>/dev/null
# chmod 666 /etc/cni/net.d/10-aws.conflist 2>>/dev/null

/etc/eks/bootstrap.sh --kubelet-extra-args "$KUBEEXTRAARGS" --b64-cluster-ca $B64_CLUSTER_CA --apiserver-endpoint $API_SERVER_URL --dns-cluster-ip $K8S_CLUSTER_DNS_IP $BOOTEXTRAARGS $CLUSTERNAME

echo "Done with bootstrapping. Good luck ;)"
