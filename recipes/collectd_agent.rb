#
# Install and configure collectd agent
#

service "iptables" do
  action :stop
end

include_recipe 'yum-epel' if node['platform_family'] == 'rhel'
include_recipe "java"

yum_repository 'ADP' do
  description "ADP Stable repo"
  baseurl "https://adp-repo.s3.amazonaws.com/centos/stable/6/$basearch"
  gpgcheck false
  enabled true
  action :create
end

package "collectd"
package "collectd-python"
package "collectd-ping"

template "/etc/collectd.conf" do
  source "collectd.conf.erb"
  mode 644
  variables({
    :logLevel => node["qubell_graphite"]["collectd_log_level"]
  })
end

directory "/etc/collectd/plugins" do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

directory node["qubell_graphite"]["collectd"]["plugins_path"] do
  owner 'root'
  group 'root'
  mode '0755'
  recursive true
  action :create
end

cookbook_file "#{node["qubell_graphite"]["collectd"]["plugins_path"]}/carbon_writer.py" do
  source 'carbon_writer.py'
  mode '0644'
  owner 'root'
  group 'root'
  action :create
end

template "/etc/collectd/plugins/carbon_writer.conf" do
  source "collectd.plugin.conf.erb"
  mode 644
  variables({
    :plugins_path => node["qubell_graphite"]["collectd"]["plugins_path"],
    :carbon_host => node["qubell_graphite"]["carbon_host"],
    :carbon_port => node["qubell_graphite"]["carbon_port"],
    :carbon_protocol => node["qubell_graphite"]["carbon_protocol"],
  })
end

file "simple_plugins.conf" do
  path "/etc/collectd/plugins/simple_plugins.conf"
  mode '0644'
  owner 'root'
  group 'root'
  content <<-EOH
    LoadPlugin cpu
    LoadPlugin df
    LoadPlugin disk
    LoadPlugin entropy
    LoadPlugin interface
    LoadPlugin irq
    LoadPlugin load
    LoadPlugin memory
    LoadPlugin processes
    LoadPlugin rrdtool
    LoadPlugin swap
    LoadPlugin users
    LoadPlugin network
    LoadPlugin uptime
    LoadPlugin ping
    EOH
end

service "collectd" do
  action :restart
end
