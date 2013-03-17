puppet-example
==============

A sample Puppet configuration for a simple PHP application created for my talk on Puppet
at [Bristol Skillswap](http://bristolskillswap.org/vagrant/)

For this example, all the Puppet files are contained within the code repo. If you were
to put this into production you'd probably want to split out the Puppet directory into a
separate repository and reference it accordingly in the Vagrantfile.

Getting started
===============

 * Install [Vagrant](http://vagrantup.com)
 * Run `vagrant up` in this directory
 * Go to http://localhost:8080 to see the resulting application (adding local.example.com
   to your hosts file as 127.0.0.1 and going to http://local.example.com:8080 will also
   work)
