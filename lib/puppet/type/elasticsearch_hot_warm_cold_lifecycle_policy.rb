$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..'))

require 'puppet_x/elastic/elasticsearch_rest_resource'

Puppet::Type.newtype(:elasticsearch_hot_warm_cold_lifecycle_policy) do
  extend ElasticsearchRESTResource
  desc 'Manages Elasticsearch hot-warm-cold lifecycle policies.'
  ensurable

  newparam(:name, :namevar => true) do
    desc 'Lifecycle policy name.'
  end

  newproperty(:hot_priority) do
    desc 'Priority set to indexes on hot phase'
  end

  newproperty(:hot_rollover_max_size) do
    desc 'Max primary shard index storage size before doing rollover'
  end

  newproperty(:hot_rollover_max_docs) do
    desc 'Max number of documents an index is to contain before rolling over'
  end

  newproperty(:hot_rollover_max_age) do
    desc 'Max time elapsed from index creation before doing rollover'
  end


  newproperty(:hot_unfollow) do
    desc 'This action turns a ccr follower index into a regular index'
  end

  newproperty(:warm_min_age) do
    desc 'Indices enter phases based on a phase’s min_age parameter. The index will not enter the phase until the index’s age is older than that of the min_age'
  end

  newproperty(:warm_priority) do
    desc 'Priority set to indexes on warm phase'
  end

  newproperty(:warm_unfollow) do
    desc 'This action turns a ccr follower index into a regular index'
  end

  newproperty(:warm_allocate_number_of_replicas) do
    desc 'The number of replicas to assign to the index'
  end

  newproperty(:warm_allocate_include) do
    desc 'Assigns an index to nodes having at least one of the attributes'
  end

  newproperty(:warm_allocate_exclude) do
    desc 'Assigns an index to nodes having none of the attributes'
  end

  newproperty(:warm_allocate_require) do
    desc 'Assigns an index to nodes having all of the attributes'
  end

  newproperty(:warm_read_only) do
    desc 'This action will set the index to be read-only'
  end

  newproperty(:warm_force_merge_max_num_segments) do
    desc 'The number of segments to merge to. To fully merge the index, set it to 1'
  end

  newproperty(:warm_shrink_number_of_shards) do
    desc 'The number of shards to shrink to. must be a factor of the number of shards in the source index'
  end

  newproperty(:cold_min_age) do
    desc 'Indices enter phases based on a phase’s min_age parameter. The index will not enter the phase until the index’s age is older than that of the min_age.'
  end

  newproperty(:cold_priority) do
    desc 'Priority set to indexes on cold phase'
  end

  newproperty(:cold_allocate_number_of_replicas) do
    desc 'The number of replicas to assign to the index'
  end

  newproperty(:cold_allocate_include) do
    desc 'Assigns an index to nodes having at least one of the attributes'
  end

  newproperty(:cold_allocate_exclude) do
    desc 'Assigns an index to nodes having none of the attributes'
  end

  newproperty(:cold_allocate_require) do
    desc 'Assigns an index to nodes having all of the attributes'
  end

  newproperty(:cold_freeze) do
    desc 'This action will freeze the index'
  end

  newproperty(:cold_unfollow) do
    desc 'This action turns a ccr follower index into a regular index'
  end

  newproperty(:delete_min_age) do
    desc 'Indices enter phases based on a phase’s min_age parameter. The index will not enter the phase until the index’s age is older than that of the min_age.'
  end

  newproperty(:delete_delete) do
    desc 'The Delete Action does just that, it deletes the index'
  end

end
