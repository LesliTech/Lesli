# Github self hosted runner
Currently we use self-hosted github runner to run our workflows for pull requests, testing, build gems and more.

**The instructions below follow the steps to install a self-hosted github runner in a ubuntu machine**

It is recommended to install and use the self-hosted github runner in a virtual machine

## Install dependencies and necessary software

### Install Docker
We use docker to create an isolated environment for every workflow & action

You can install docker following this steps:
[https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04)

**IMPORTANT:** Docker needs to have a specific folder for cache, make sure you have /opt/hostedtoolcache and it's writable by runner user. Easiest way to achieve this:
`mkdir /opt/hostedtoolcache && chmod -R 777 /opt/hostedtoolcache`

### Install Nodejs
We use Nodejs to build the web frontend

You can install docker following this steps:
[https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-20-04)

### PostgreSQL
Ruby needs some tools to be able to compile the pg gem while bundle install

`sudo apt-get -y install libpq-dev`


## Installing the Github Runner
**NOTE:** This instructions are for Ubuntu 20.04, the binaries, shasums, tokens, settings and the packages may be different for MacOS or Windows

**IMPORTANT:** Github provide an unique token to identify, validate and authenticate the runner, so the instructions bellow are not going to work if you do not provide the token for your runner.

### Create a folder
**NOTE:** It is recommended to install the runner in the home of your user
`mkdir actions-runner && cd actions-runner`

### Download the latest runner package

`curl -o actions-runner-linux-x64-2.287.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.287.1/actions-runner-linux-x64-2.287.1.tar.gz``

### Optional: Validate the hash
`echo "8fa64384d6fdb764797503cf9485e0s273179079cs837bfc2b298b1a8fd01d52  actions-runner-linux-x64-2.287.1.tar.gz" | shasum -a 256 -c``

### Extract the installer
`tar xzf ./actions-runner-linux-x64-2.287.1.tar.gz`

### Create the runner and start the configuration experience
**IMPORTANT:** This is not a valid token, you must ask for a new token for your runner to the Github administrator.

The installer is going to ask for a few details while configuring the runner, use the default options works well for our use case, just be sure to asign a good name to your runner to make it easy to identify in the github runners administration area, a good name could be something like: "ldonis-virtual-ubuntu-1" or "aws-ubuntu-2"
`./config.sh --url https://github.com/leitfaden --token AAWBBDYOJ65TVBFYHT6ADR4B7VFA4`

### Last step, run it!
`./run.sh`

## Configuring the self-hosted runner application as a service

### Installing the service
`sudo ./svc.sh install`

### Start the service with the following command:
sudo ./svc.sh start

### Stopping the service
sudo ./svc.sh stop

### Uninstalling the service

- Stop the service if it is currently running.
- Uninstall the service with the following command:
- `sudo ./svc.sh uninstall`
