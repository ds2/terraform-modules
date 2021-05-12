%{ for u in userArns ~}
- userarn: ${u}
  username: ${admUser}
  groups:
    - system:masters
%{ endfor ~}
