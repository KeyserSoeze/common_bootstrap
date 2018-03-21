# Ansible Role: common_bootstrap

Performs some basic post-install tasks on Debian/Ubuntu servers: Creates admin & ansible accounts (with passwordless sudo), basic SSH security, can modify basic network settings & motd, can install unattended-upgrades and some essential packages.

This role can be copied and modified, if needed for special environments/organizations.

## Requirements

No special requirements.
Note that this role requires root access, so run it with a `become: yes`.

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml` for detailed documentation):

    bootstrap__tests: false
    bootstrap__network: false
    bootstrap__system: false
    bootstrap__packages: [ 'unattended-upgrades', 'vim', 'htop' ]

Controls wether some task-groups are executed: connection-tests for debugging, network-configuration (needs `bootstrap__ipv4` in host_vars) and some basic system-configurations (like installation of some essential packages).

    bootstrap__admin_ansible_sshkey: ''
    bootstrap__admin_ansible_user:
      - name: 'ansible-login'
        system: true
        groups: []
        comment: 'ansible login'
        shell: '/bin/bash'
        sshkey: "{{ bootstrap__admin_ansible_sshkey }}"
        passwordless_sudo: true
        convenience: false

Creates the ansible user, if sshkey is set here or better in group_vars.
This structure of settings can also be used to create other admin accounts (see below).

    bootstrap__admin_users: []
    bootstrap__admin_system: false
    bootstrap__admin_groups: [ 'adm', 'sudo' ]
    bootstrap__admin_comment: 'System Administrator'
    bootstrap__admin_shell: '/bin/bash'
    bootstrap__admin_convenience: true

List of additional admin user accounts created by the role.
The following variables are defaults for this accounts, if not set as described above in `bootstrap__admin_ansible_user`.

## Dependencies

None.

## Example Playbook

Say the following playbook is called `common_bootstrap.yml`:

    - name: some common configurations and post-install tasks
      hosts: deploy
      become: true
      vars:
        admin_users:
          - name: 'adminuser1'
            sshkey: 'ssh-rsa ...'
            passwordless_sudo: true
        bootstrap__admin_users: "{{ hostvars[inventory_hostname]['bootstrap__admin_users'] | d(admin_users) }}"
        bootstrap__admin_ansible_sshkey: 'ssh-rsa ...'
        bootstrap__system: true

      roles:
        - keysersoeze.common_bootstrap

Then you can run this playbook as shown in the following Usage-Examples:

* `ansible-playbook common_bootstrap.yml -u USERNAME -k -K`
* `ansible-playbook common_bootstrap.yml -i HOSTNAME, -u USERNAME -k -K`
* `ansible-playbook common_bootstrap.yml`

Change target hosts (group deploy) in hosts file or change `hosts` to `all` and call this playbook with inventory parameter (`-i`).
For first deployment of admin users, it may be necessary to call with `-u USERNAME` `-k`/`--ask-pass` `-K`/`--ask-become-pass`.

## License

GPL-3.0
