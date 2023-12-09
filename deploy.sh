#!/bin/bash

# Set your deployment package name
PACKAGE_NAME="deployment_package.zip"

# Initialize options
CLEAN=0
AUTO_APPROVE=0

# Parse options
while getopts "ca" opt; do
  case ${opt} in
    c)
      CLEAN=1
      ;;
    a)
      AUTO_APPROVE=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
  esac
done

# Clean package directory if -c option is set
if [ $CLEAN -eq 1 ]; then
  echo "Cleaning package directory..."
  rm -rf ./package/*
fi

# Install dependencies into the package directory
pip install -r requirements.txt -t ./package/

# Add your code to the package
cp -r src/. package/

# Create a ZIP archive of the package
cd package
zip -r ../$PACKAGE_NAME .
cd ..

# Apply your Terraform configuration
cd terraform
if [ $AUTO_APPROVE -eq 1 ]; then
  terraform apply -auto-approve
else
  terraform apply
fi