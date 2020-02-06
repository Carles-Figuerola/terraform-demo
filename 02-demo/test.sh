#!/bin/bash

echo "Initialize terraform"
terraform init
# terraform plan
echo -e '\nApply terraform changes (review before applying!)'
terraform apply
