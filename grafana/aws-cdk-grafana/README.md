# Deploy Grafana with AWS CDK for Python

This project deploys Grafana using the CDK development with Python.

## Prerequisites

* AWS account
* Install and configure the [AWS Command Line Interface (CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html). The AWS CLI configuration is used to store, manage, and generate security credentials for use with the CDK CLI.
* Install Node.js used for installing the AWS CDK.
* Install other programming langugage prerequisites which are used to develop AWS CDK applications.
    * Python 3.7 or later including pip and virtualenv

All AWS CDK developers, regardless of the supported programming language that you will use, require Node.js 14.15.0 or later. All supported programming languages use the same backend, which runs on Node.js. We recommend a version in active long-term support.

Node.js versions 13.0.0 through 13.6.0 are not compatible with the AWS CDK due to compatibility issues with its dependencies.

## Install [Node.js](https://nodejs.org/en/download/)

```bash
# installs fnm (Fast Node Manager)
curl -fsSL https://fnm.vercel.app/install | bash

# activate fnm
source ~/.bashrc

# download and install Node.js
fnm use --install-if-missing 20

# verifies the right Node.js version is in the environment
node -v # should print `v20.15.1`

# verifies the right npm version is in the environment
npm -v # should print `10.7.0`
```

## Install the AWS CDK CLI

```bash
npm install -g aws-cdk
cdk --version
```

### Install [Python, pip, and venv](https://learn.microsoft.com/en-us/windows/python/web-frameworks)

```bash
sudo apt update && sudo apt upgrade
sudo apt upgrade python3
python3 --version
sudo apt install python3-pip
sudo apt install python3-venv
```

### Working with the [AWS CDK in Python](https://docs.aws.amazon.com/cdk/v2/guide/work-with-cdk-python.html)


### Open the CDK project

```bash
cd grafana/aws-cdk-grafana/
```

### Create a virtual environment

Create the virtual environment inside the directory in which you plan to have your project.

```bash
python3 -m venv .venv
```

### Activate virtual environment

```bash
source .venv/bin/activate # On Windows, run `.\venv\Scripts\activate`
python -m pip install -r requirements.txt
```

### List the CDK stacks in your app

```bash
cdk list
```

### Synthesize the CloudFormation template for this code.

```bash
cdk synth
```

To add additional dependencies, for example other CDK libraries, just add them to your `setup.py` file and rerun the `pip install -r requirements.txt` command.

### Bootstrap environment

```bash
cdk bootstrap aws://851725631136/ap-southeast-2
```

### Deploy

```bash
cdk deploy --profile ncs
```

### Deactivate virtual environment

```bash
deactivate
```

## Useful CDK commands

 * `cdk ls`          list all stacks in the app
 * `cdk synth`       emits the synthesized CloudFormation template
 * `cdk deploy`      deploy this stack to your default AWS account/region
 * `cdk diff`        compare deployed stack with current state
 * `cdk docs`        open CDK documentation
