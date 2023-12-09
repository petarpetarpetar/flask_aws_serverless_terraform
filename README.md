# AWS Serverless Lambda Deployment with Terraform

This project provides a template for deploying a Python AWS Lambda function using Terraform.

## Prerequisites

- Python 3.6 or later
- AWS CLI configured with your credentials
- Terraform 0.12 or later

## Deployment

0. All of the below commands are written in `deploy.sh`. If you give it executable permission (by running `chmod +x deploy.sh`) then you can automatically execute the deployment by running

```bash
./deploy.sh
```

The command above also accepts two flags:

- `-c` for clean install. This will delete all downloaded packages/libraries and will reinstall them.
- `-a` for autoaccepting terraform changes.

Run `./deploy -c -a` and you'll be good to go.

However, if you can't or don't wish to do that, you can run every command step by step:

1. Install the Python dependencies into a `package` directory:

```bash
pip install -r requirements.txt -t ./package/
```

2. Copy your Python script to the `package` directory:

```bash
cp -r src/. package/
```

3. Create a ZIP archive of the `package` directory:

```bash
cd package
zip -r ../deployment_package.zip .
```

4. Initialize and apply Terraform configuration:

```bash
cd ../terraform
terraform init
terraform apply
```
