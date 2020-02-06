#!/bin/bash

echo "Initialize terraform"
terraform init
# terraform plan
echo -e '\nApply terraform changes (review before applying!)'
terraform apply
echo -e "\nSee the secret created"
kubectl get secret docker-secrets -o yaml

echo -e "\nUnencode the secret to confirm is what we expect"
kubectl get secret docker-secrets -o yaml | yq r - data[.dockerconfigjson] | base64 -D
