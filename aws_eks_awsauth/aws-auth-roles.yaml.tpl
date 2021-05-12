%{ for r in roleArns ~}
- rolearn: ${r}
  username: system:node:{{EC2PrivateDNSName}}
  groups:
    - system:bootstrappers
    - system:nodes
%{ endfor ~}
