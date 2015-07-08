#
# Cookbook Name:: OpenLdap
# Recipe:: cert_setting
#
# Copyright 2015, Relevance PVT LTD, Inc.
#
# All rights reserved - Do Not Redistribute
#

ldap = node['OpenLdap']
syscfg_loc = ldap['syscfg_loc']
syscfg_LDAP_key = ldap['syscfg_LDAP_key']
syscfg_LDAPI_key = ldap['syscfg_LDAPI_key']
syscfg_LDAPS_key = ldap['syscfg_LDAPS_key']
SLAPD_LDAPline = "#{ldap['syscfg_LDAP_key']}=#{ldap['syscfg_LDAP_val']}"
SLAPD_LDAPIline = "#{ldap['syscfg_LDAPI_key']}=#{ldap['syscfg_LDAPI_val']}"
SLAPD_LDAPSline ="#{ldap['syscfg_LDAPS_key']}=#{ldap['syscfg_LDAPS_val']}"

#Create generated cert file for Openldap
["#{ldap['ldap_pubkey']}", "#{ldap['ldap_privkey']}"].each do |cert|

	template "#{ldap['cert_loc']}/#{cert}" do
	  source "#{cert}.erb"
	  owner "#{ldap['user']}"
	  group "#{ldap['group']}"
	  mode 0644
	  action :create
	end

end

#Generated ldap.conf file for Openldap
template "#{ldap['home_path']}/#{ldap['lapd_file']}" do
	source "#{ldap['lapd_file']}.erb"
	variables(
			:TLS_CACERTDIR => ldap['cert_loc'],
			:olcSuffix => ldap['olcSuffix']					
	        )	
	owner "#{ldap['user']}"
	group "#{ldap['group']}"
	mode 0644
	notifies :restart, "service[Restart_Ldap]", :immediately	
	action :create
end

#Update OpenLdap config file for enabling certs settings and Sysconfig file
# ruby_block "Update #{ldap['syscfg_loc']} file of OpenLdap" do
# 	block do
# 	  begin
# 	    UpdateFile.updateParam(syscfg_loc, syscfg_LDAP_key, SLAPD_LDAPline) if UpdateFile.propNotExists(syscfg_loc, SLAPD_LDAPline)	  	
# 	    UpdateFile.updateParam(syscfg_loc, syscfg_LDAPI_key, SLAPD_LDAPIline) if UpdateFile.propNotExists(syscfg_loc, SLAPD_LDAPIline)
# 	    UpdateFile.updateParam(syscfg_loc, syscfg_LDAPS_key, SLAPD_LDAPSline) if UpdateFile.propNotExists(syscfg_loc, SLAPD_LDAPSline)	 	    
# 	rescue Exception => e
# 		puts e.message
# 	  end
# 	end
# end

#Restart OpenLdap Service
service "Restart_Ldap" do
	service_name "#{ldap['service_name']}"
	action :nothing
end