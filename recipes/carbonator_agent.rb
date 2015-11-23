#
# Installs and configure Carbonator windows client to carbone
#

directory "#{node["qubell_graphite"]["tmp"]}" do
  rights :full_control, 'Administrators'
  inherits true
  action :create
end

remote_file "#{node["qubell_graphite"]["tmp"]}/carbonator.zip" do
  source node["qubell_graphite"]["carbonator_url"]
  action :create
end

batch "unzip carbonator.zip" do
  cwd "#{node["qubell_graphite"]["win_install_path"]}"
  code <<-EEND
    unzip.exe -o #{node["qubell_graphite"]["tmp"]}/carbonator.zip
  EEND
end

batch "add Carbonator service" do
  code <<-EEND
    cd #{node["qubell_graphite"]["carbonator_path"]}
    if exist remove-service.cmd (
      remove-service.cmd
      install-service.cmd 
    ) else ( 
      install-service.cmd 
    )
  EEND
end

batch "carbonator service restart" do
  code <<-EEND
    net stop carbonator
    net start carbonator
  EEND
  action :nothing
end


template "#{node["qubell_graphite"]["carbonator_path"]}/Crypton.Carbonator.exe.config" do
  source "crypton.erb"
  variables ({
    :carbon_host => node["qubell_graphite"]["carbon_host"],
    :carbon_port => node["qubell_graphite"]["carbon_port"]
  })
  notifies :run, "batch[carbonator service restart]"
end


