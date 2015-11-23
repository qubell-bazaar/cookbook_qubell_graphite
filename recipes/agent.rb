case node["platform_family"]
when "windows"
  include_recipe "qubell_graphite::carbonator_agent"
when "rhel"
  include_recipe "qubell_graphite::collectd_agent"
end
