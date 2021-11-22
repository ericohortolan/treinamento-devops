#!/bin/bash

cd 08-jenkins/deploy-infra-img-java-app/terraform
/var/lib/jenkins/plugins/terraform destroy -auto-approve
