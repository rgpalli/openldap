#
# Cookbook Name:: OpenLdap
# Recipe:: ubuntu
#
# Copyright 2015, Relevance PVT LTD, Inc.
#
# All rights reserved - Do Not Redistribute
#

ldap = node['OpenLdap']

# Set Debian Frontend noninteractive
execute "set_frontend_noninteractive" do
	command "export DEBIAN_FRONTEND=noninteractive"
	# only_if {node['platform'] == "ubuntu"}
end

#apt-get-update
execute "apt_update" do
	command "apt-get update"
	action :run
	# only_if {node['platform'] == "ubuntu"}
end

#Install All required OpenLdap Packages
ldap['pckg'].each do |pkg|
	package pkg do
		action :install
	end
end

directory "#{ldap['cert_loc']}" do
	owner ldap[:user]
	group ldap[:group]	
	mode 0755
	action :create
	recursive true
end

#Create file for parameter for new database needed for LDAP
template "#{ldap['db_loc']}/#{ldap['db_file']}" do
	source "#{ldap['db_file']}.erb"
	owner "#{ldap['user']}"
	group "#{ldap['group']}"
	mode 0644
	action :create
end

#Create SLAPD Config file of LDAP
template "#{ldap['home_path']}/#{ldap['slapd_file']}" do
	source "#{ldap['slapd_file']}.erb"
	variables(
			:olcSuffix => ldap['olcSuffix'],
			:olcRootDN => ldap['olcRootDN'],
			:olcRootPW => ldap['olcRootPW'],
			:TLSCACertificatePath => "#{ldap['cert_loc']}",
			:TLSCertificateFile => "#{ldap['cert_loc']}/#{ldap['ldap_pubkey']}",
			:TLSCertificateKeyFile => "#{ldap['cert_loc']}/#{ldap['ldap_privkey']}",
			:home_path => "#{ldap['home_path']}",
			:pid_loc => "#{ldap['pid_loc']}",
			:mod_loc => "#{ldap['mod_loc']}"			
	        )
	owner "#{ldap['user']}"
	group "#{ldap['group']}"
	mode 0644
	notifies :run, "execute[Clean_SLAPD_directory]", :immediately	
	action :create
end

#Clean up all content and previous existing LDAP configuration and files, incase if exists. And re-initialize them.
execute "Clean_SLAPD_directory" do
	command "rm -rf #{ldap['slapd_path']}/*"
	notifies :run, "execute[Convert_cfg_file]", :immediately	
	action :nothing
end

# Convert configuration file into dynamic configuration under /etc/openldap/slapd.d/ directory
execute "Convert_cfg_file" do
	command "slaptest -f #{ldap['home_path']}/#{ldap['slapd_file']} -F #{ldap['slapd_path']}"
	notifies :run, "execute[set_permission]", :immediately
	action :nothing
end

# Set permission on /var/lib/ldap/ and /etc/openldap/slapd.d/ to ldap
execute "set_permission" do
	command "chown -R #{ldap['user']}. #{ldap['slapd_path']}"
	notifies :restart, "service[Restart_OpenLdap]", :immediately
	action :nothing
end

#Restart OpenLdap Service
service "Restart_OpenLdap" do
	service_name "#{ldap['service_name']}"
	action :restart
end


#Enable encrypted connection
include_recipe "OpenLdap::cert_setting" 

# #Setup phpldapadmin for GUI access of OpenLdap
include_recipe "OpenLdap::phpldapadmin" if ldap['phpldapadmin_install']