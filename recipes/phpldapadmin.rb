#
# Cookbook Name:: OpenLdap
# Recipe:: phpldapadmin
#
# Copyright 2015, Relevance PVT LTD, Inc.
#
# All rights reserved - Do Not Redistribute
#

ldap = node['OpenLdap']
ip_octet = node[:ipaddress].split('.')
extracted_ip = ip_octet[0].concat(".").concat(ip_octet[1])
ldapadmin_cfg_file = "#{ldap['phpldapadmin_home']}/#{ldap['phpldapadmin_cfg_file']}"
ldapadmin_cfg_line = "#{ldap['phpldapadmin_cfg_line']}"
updated_cfg_line = "//#{ldap['phpldapadmin_cfg_line']}"

# Install Epel package
execute "Install Epel package" do
	command "rpm -ivh #{ldap['epel_url']}"
	not_if %{rpm -qa| grep epel}
	not_if {node['platform'] == "ubuntu"}
end

#Install All required phpldapadmin Packages
ldap['phpldapadmin_pckg'].each do |pkg|
	package pkg do
		action :install
	end
end

#create phpldapadmin config file
template "#{ldap['phpldapadmin_home']}/#{ldap['phpldapadmin_cfg_file']}" do
	source "#{ldap['phpldapadmin_cfg_file']}.erb"
	mode 0640
	group "#{ldap['httpd_grp']}"	
	action :create
end

template "#{ldap['httpd_cfg_path']}/#{ldap['httpd_php_cfg_file']}" do
	source "#{ldap['httpd_php_cfg_file']}.erb"
	variables(
			:extracted_ip => extracted_ip
	        )
	mode 0644
	notifies :restart, "service[Restart_Apache]", :immediately	
	action :create
end


#Start httpd Service
service "Restart_Apache" do
	service_name "#{ldap['httpd_serv_name']}"
	action :nothing
end