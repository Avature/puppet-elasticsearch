$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..'))

require 'puppet_x/elastic/elasticsearch_rest_resource'

Puppet::Type.newtype(:elasticsearch_hot_warm_cold_lifecycle_policy) do
  extend ElasticsearchRESTResource
  desc 'Manages Elasticsearch hot-warm-cold lifecycle policies.'
  ensurable

  newparam(:name, :namevar => true) do
    desc 'Lifecycle policy name.'
  end

  newproperty(:cold_min_age) do
    desc 'Indices enter phases based on a phase’s min_age parameter. The index will not enter the phase until the index’s age is older than that of the min_age.'
  end

  newproperty(:cold_allocate_require) do
    desc 'Assigns an index to nodes having all of the attributes'
  end

end
