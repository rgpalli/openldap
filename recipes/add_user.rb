#
# Cookbook Name:: OpenLdap
# Recipe:: add_user
#
# Copyright 2015, Relevance PVT LTD, Inc.
#
# All rights reserved - Do Not Redistribute
#


ldap = node['OpenLdap']
domain = ldap['olcSuffix'].split(',')
domain_ldif = "#{ldap['home_path']}/#{ldap['olcRootDN_cn']}.ldif"

#Create Domain and SuperAdmin LDIF file for OpenLdap
template "#{ldap['home_path']}/#{ldap['olcRootDN_cn']}.ldif" do
	source "#{ldap['olcRootDN_cn']}.erb"
	owner ldap['user']
	group ldap['group']
	variables(
		:olcSuffix => ldap['olcSuffix'],
		:superuserDN => ldap['superuserDN'],
		:superuser => ldap['superuser'],
		:superuser_pswd => ldap['superuser_pswd'],
		:domain1 => domain[0].split('=')[1],
		:domain2 => domain[1].split('=')[1]			
	)	  
	mode 0644
	not_if %{ldapsearch -x -D '#{ldap['olcRootDN']}' -w #{ldap['plain_olcRootPW']}|grep -v grep |grep #{ldap['superuser']}}	
	action :create
end

#Add Domain entries to OpenLdap
execute "Add Entry for #{ldap['olcSuffix']}" do
	command "ldapadd -x -D '#{ldap['olcRootDN']}' -f #{domain_ldif} -w #{ldap['plain_olcRootPW']}"
	not_if %{ldapsearch -x -D '#{ldap['olcRootDN']}' -w #{ldap['plain_olcRootPW']}|grep -v grep |grep #{ldap['superuser']}}
	notifies :restart, "service[Restart_Ldap_After_useradd]", :immediately	
end

file "#{ldap['home_path']}/#{ldap['olcRootDN_cn']}.ldif" do
	action :delete
end

#Restart OpenLdap Service
service "Restart_Ldap_After_useradd" do
	service_name "#{ldap['service_name']}"
	action :nothing
end