ansible-fullstack-django
========================

Generic ansible django deployment script, intended to be used in a VM where no other services are running,
and to be invoked with environment variables.

Tested on debian/jessie.

- python3.4
- uwsgi
- postgresql
- nginx

- sass


Getting started
---------------

You need to install the following requirements:

Ansible >=2.1.1
Ansible roles:
   - geerlingguy.security
   - geerlingguy.firewall
   - ANXS.postgresql
   - jdauphant.nginx
   - andrewrothstein.ruby
   - ashwoods.uwsgi-emperor


Using the deployment script
---------------------------

For convenience you can use the deploy.sh script:

    ./deploy.sh [target] [project_git_url] [remote_user] [project_url] [project_name] [git_ref]
