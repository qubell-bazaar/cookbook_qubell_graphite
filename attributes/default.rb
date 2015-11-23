default["qubell_graphite"]["carbon_host"] = "localhost"
default["qubell_graphite"]["carbon_port"] = 2003
default["qubell_graphite"]["carbon_protocol"] = "tcp"

default["qubell_graphite"]["collectd_log_level"] = "info"
default["qubell_graphite"]["collectd"]["plugins_path"] = "/opt/collectd-plugins"

default["qubell_graphite"]["tmp"] = "C:/tmp"
default["qubell_graphite"]["win_install_path"] = "C:/Program\ Files"
default["qubell_graphite"]["carbonator_url"] = "https://s3.amazonaws.com/qubell-starter-kit-artifacts/deps/Carbonator.zip"
default["qubell_graphite"]["carbonator_path"] = "#{node["qubell_graphite"]["win_install_path"]}/Carbonator"
