#
# Cookbook Name:: OpenLdap
# Recipe:: default
#
# Copyright 2015, Relevance PVT LTD, Inc.
#
# All rights reserved - Do Not Redistribute
#


case node['os']
        when "linux"
                case node['platform']
                        when "redhat", "centos"
                        	include_recipe "OpenLdap::openldap_master"
                        when "ubuntu"
                        	include_recipe "OpenLdap::ubuntu"
                        else
                        	Chef::Log.info("Sorry, There is no recipe for #{node['platform']} yet!!!")
                end
        else
                Chef::Log.info("Sorry, There is no recipe for #{node['os']} yet!!!")
end