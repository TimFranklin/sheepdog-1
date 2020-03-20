# Ansible Playbooks to Deploy Sheepdog with WebGoat7

These two ansible playbooks automate the deployment and cleanup of Sheepdog and WebGoat7 to quickly setup a demo environment using the Contrast Security Secure DevOps Platform.

## To use this playbook, follow the instructions below

### Create and edit a '.contrast.cfg' file
The playbook relies on API credentials in this file to connect to your target Contrast TeamServer.
```
username: [username]
service_key: [service_key]
teamserver_url: [teamserver_url]
teamserver_organization: [teamserver_organization]
api_key: [api_key]
```

### Clone this github repo.
```
$ git clone git@github.com:Contrast-Security-OSS/sheepdog.git
```
### Run the ansible playbook
```
$ ansible-playbook ./sheepdog/ansible/main.yml
```

### Execute attack.sh
**Note:** ```attack.sh``` will take several hours to run due to the numerous applications it will be simulating

```
$ cd ~/webgoat7
$ ./attack.sh
```

## Cleanup
```
ansible-playbook ./sheepdog/ansible/cleanup.yml
```
