# personalWGserver
Ansible playbook and related files to set up a personal WorkGroup server.

This project is inteded to satisfy little needs one can expect from a workgroup server.

The server should be small enough to be hosted everywhere in the cloud, or even in a [RaspBerry Pi](https://www.raspberrypi.org/) .

## Requirements
For the client host to run this playbook, the requirements are:

- [Ansible](https://www.ansible.com/) 2.0.0.2 or later.
- An internet connection ;-)

If you intend to test the project with the attached Vagrantfile, you'll also need:

- [Vagrant](https://www.vagrantup.com/) 1.9.1 or later

## Features implemented
The features implemented so far are:

- Solid base operating system: [Debian](https://www.debian.org) .
- Secure networking with [OpenVPN](https://openvpn.net/) .