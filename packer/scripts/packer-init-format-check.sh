#!/bin/bash
set -e

echo "Initialising Packer..."
packer init packer/template/jenkins-ami-template.pkr.hcl

echo "Checking if Packer templates require formatting..."
if packer fmt -check -diff -recursive packer; then
  echo "All Packer templates are correctly formatted."
else
  echo "Packer templates require formatting. Please run 'packer fmt -recursive packer' locally and commit the changes."
  exit 1
fi