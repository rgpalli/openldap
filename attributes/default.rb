#
# Cookbook Name:: OpenLdap
# Attribute:: default
#
# Copyright 2015, Relevance PVT LTD, Inc.
#
# All rights reserved - Do Not Redistribute
#

case node['platform']
    when "redhat", "centos"
      default['OpenLdap']['home_path'] = "/etc/openldap"
      default['OpenLdap']['user'] = "ldap"
      default['OpenLdap']['group'] = "ldap"
      default['OpenLdap']['pid_loc'] = "openldap"      
      default['OpenLdap']['mod_loc'] = "openldap"            
      default['OpenLdap']['pckg'] = ["openldap", "openldap-servers", "openldap-clients"]
      default['OpenLdap']['httpd_serv_name'] = "httpd"
      default['OpenLdap']['httpd_grp'] = "apache"

    when "ubuntu"
      default['OpenLdap']['home_path'] = "/etc/ldap"
      default['OpenLdap']['user'] = "openldap"
      default['OpenLdap']['group'] = "openldap"
      default['OpenLdap']['pid_loc'] = "slapd"    
      default['OpenLdap']['mod_loc'] = "ldap"                  
      default['OpenLdap']['pckg'] = ["slapd", "ldap-utils"]
      default['OpenLdap']['httpd_serv_name'] = "apache2"
      default['OpenLdap']['httpd_grp'] = "www-data"
    else
    Chef::Log.info("Sorry, There is no Attribute for #{node['platform']} yet!!!")
end

#OpenLdap Setup
default['OpenLdap']['db_file'] = "DB_CONFIG"
default['OpenLdap']['db_loc'] = "/var/lib/ldap"
default['OpenLdap']['slapd_file'] = "slapd.conf"
default['OpenLdap']['lapd_file'] = "ldap.conf"
default['OpenLdap']['olcSuffix_key'] = "olcSuffix"
default['OpenLdap']['olcSuffix_org'] = "dc=acme,dc=com"
default['OpenLdap']['olcSuffix'] = "dc=d4d-ldap,dc=relevancelab,dc=com"
default['OpenLdap']['superuser'] = "superadmin"
default['OpenLdap']['superuserDN'] = "cn=#{node['OpenLdap']['superuser']},#{node['OpenLdap']['olcSuffix']}"
default['OpenLdap']['superuser_pswd'] = "superadmin@123"
default['OpenLdap']['olcRootDN_key'] = "olcRootDN"
default['OpenLdap']['olcRootDN_cn'] = "admin"
default['OpenLdap']['olcRootDN'] = "cn=#{node['OpenLdap']['olcRootDN_cn']},#{node['OpenLdap']['olcSuffix']}"
default['OpenLdap']['olcRootDN_cn_org'] = "Manager"
default['OpenLdap']['olcRootDN_org'] = "cn=#{node['OpenLdap']['olcRootDN_cn_org']},#{node['OpenLdap']['olcSuffix']}"
default['OpenLdap']['olcRootPW_key'] = "olcRootPW"
default['OpenLdap']['plain_olcRootPW'] = "ReleV@ance"
default['OpenLdap']['olcRootPW'] = "{SSHA}ZwaPgl4D87pnBsfH47vbs9dDZiGRew32"
default['OpenLdap']['service_name'] = "slapd"
default['OpenLdap']['slapd_path'] = "#{node['OpenLdap']['home_path']}/slapd.d"

#Self Signed certificates settings
default['OpenLdap']['ldap_pubkey'] = "ldap_pubkey.pem"
default['OpenLdap']['ldap_privkey'] = "ldap_privkey.pem"
default['OpenLdap']['cert_loc'] = "#{node['OpenLdap']['home_path']}/certs"
default['OpenLdap']['syscfg_loc'] = "/etc/sysconfig/ldap"
default['OpenLdap']['syscfg_LDAP_key'] = "SLAPD_LDAP"
default['OpenLdap']['syscfg_LDAP_val'] = "no"
default['OpenLdap']['syscfg_LDAPI_key'] = "SLAPD_LDAPI"
default['OpenLdap']['syscfg_LDAPI_val'] = "no"
default['OpenLdap']['syscfg_LDAPS_key'] = "SLAPD_LDAPS"
default['OpenLdap']['syscfg_LDAPS_val'] = "yes"

#PhpLdapAdmin Setup
default['OpenLdap']['epel_url'] = "http://mirrors.ukfast.co.uk/sites/dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm"
default['OpenLdap']['phpldapadmin_install'] = "true"
default['OpenLdap']['phpldapadmin_pckg'] = ["phpldapadmin"]
default['OpenLdap']['phpldapadmin_home'] = "/etc/phpldapadmin"
default['OpenLdap']['phpldapadmin_cfg_file'] = "config.php"
default['OpenLdap']['httpd_home'] = "/etc/#{node['OpenLdap']['httpd_serv_name']}"
default['OpenLdap']['httpd_cfg_path'] = "#{node['OpenLdap']['httpd_home']}/conf.d"
default['OpenLdap']['httpd_php_cfg_file'] = "phpldapadmin.conf"

