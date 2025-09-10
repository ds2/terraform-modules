%{ for g in groupArns ~}
- grouparn: ${g}
  username: admin
  groups:
    - system:masters
%{ endfor ~}
