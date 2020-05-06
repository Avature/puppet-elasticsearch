$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', '..'))

require 'puppet/provider/elastic_rest'

Puppet::Type.type(:elasticsearch_hot_warm_cold_lifecycle_policy).provide(
  :ruby,
  :parent => Puppet::Provider::ElasticREST,
  :api_uri => '_slm/policy'
) do
  desc 'A REST API based provider to manage Elasticsearch hot-warm-cold lifecycle policy.'
  mk_resource_methods
  def self.process_body(body)
    phases = JSON.parse(body)['policy']['phases']
    hotPhasePresent = phases['hot'] != nil
    warmPhasePresent = phases['warm'] != nil
    coldPhasePresent = phases['cold'] != nil
    deletePhasePresent = phases['delete'] != nil
    results =
      {
        :name                              => 'policy',
        :ensure                            => :present,
        :hot_priority                      => if !hotPhasePresent then nil else phases['hot']['priority'] end,
        :hot_rollover_max_size             => if !hotPhasePresent || phases['hot']['actions']['rollover'].nil? then nil else phases['hot']['actions']['rollover']['max_size'] end,
        :hot_rollover_max_docs             => if !hotPhasePresent || phases['hot']['actions']['rollover'].nil? then nil else phases['hot']['actions']['rollover']['max_docs'] end,
        :hot_rollover_max_age              => if !hotPhasePresent || phases['hot']['actions']['rollover'].nil? then nil else phases['hot']['actions']['rollover']['max_age'] end,
        :hot_unfollow                      => if !hotPhasePresent then nil else phases['hot']['actions']['unfollow'] end,
        :warm_min_age                      => if !warmPhasePresent then nil else phases['warm']['min_age'] end,
        :warm_priority                     => if !warmPhasePresent then nil else phases['warm']['priority'] end,
        :warm_unfollow                     => if !warmPhasePresent then nil else phases['warm']['actions']['unfollow'] end,
        :warm_allocate_number_of_replicas  => if !warmPhasePresent || phases['warm']['actions']['allocate'].nil? then nil else phases['warm']['actions']['allocate']['number_of_replicas'] end,
        :warm_allocate_include             => if !warmPhasePresent || phases['warm']['actions']['allocate'].nil? then nil else phases['warm']['actions']['allocate']['include'] end,
        :warm_allocate_exclude             => if !warmPhasePresent || phases['warm']['actions']['allocate'].nil? then nil else phases['warm']['actions']['allocate']['exclude'] end,
        :warm_allocate_require             => if !warmPhasePresent || phases['warm']['actions']['allocate'].nil? then nil else phases['warm']['actions']['allocate']['require'] end,
        :warm_read_only                    => if !warmPhasePresent then nil else phases['warm']['actions']['read_only'] end,
        :warm_force_merge_max_num_segments => if !warmPhasePresent || phases['warm']['actions']['forcemerge'].nil? then nil else phases['warm']['actions']['forcemerge']['max_num_segments'] end,
        :warm_shrink_number_of_shards      => if !warmPhasePresent || phases['warm']['actions']['shrink'].nil? then nil else phases['warm']['actions']['shrink']['number_of_shards'] end,
        :cold_min_age                      => if !coldPhasePresent then nil else phases['cold']['min_age'] end,
        :cold_priority                     => if !coldPhasePresent then nil else phases['cold']['priority'] end,
        :cold_allocate_number_of_replicas  => if !coldPhasePresent || phases['cold']['actions']['allocate'].nil? then nil else phases['cold']['actions']['allocate']['number_of_replicas'] end,
        :cold_allocate_include             => if !coldPhasePresent || phases['cold']['actions']['allocate'].nil? then nil else phases['cold']['actions']['allocate']['include'] end,
        :cold_allocate_exclude             => if !coldPhasePresent || phases['cold']['actions']['allocate'].nil? then nil else phases['cold']['actions']['allocate']['exclude'] end,
        :cold_allocate_require             => if !coldPhasePresent || phases['cold']['actions']['allocate'].nil? then nil else phases['cold']['actions']['allocate']['require'] end,
        :cold_freeze                       => if !coldPhasePresent then nil else phases['cold']['actions']['freeze'] end,
        :cold_unfollow                     => if !coldPhasePresent then nil else phases['cold']['actions']['unfollow'] end,
        :delete_min_age                    => if !deletePhasePresent then nil else phases['delete']['min_age'] end,
        :delete_delete                     => if !deletePhasePresent then nil else phases['delete']['actions']['delete'] end,
        :provider                          => name
      }
    results
  end

  def generate_body
    body = {
      'phases' => {
        'hot'    => {
          'actions' => {
            'set_priority' => {
              'priority' => resource[:hot_priority]
            }
          }
        },
        'warm'   => {
          'actions' => {
            'set_priority' => {
              'priority' => resource[:warm_priority]
            }
          }
        },
        'cold'   => {
          'actions' => {
            'set_priority' => {
              'priority' => resource[:cold_priority]
            }
          }
        },
        'delete' => {
          'actions' => {}
        }
      }
    }
    setOrDelete(
      body['phases']['hot']['actions'],
      resource[:hot_rollover_max_size].present? || resource[:hot_rollover_max_docs].present? || resource[:hot_rollover_max_age].present?,
      'rollover',
      {}
    )
    setOrDelete(body['phases']['hot']['actions']['rollover'], resource[:hot_rollover_max_size.present?], 'max_size', resource[:hot_rollover_max_size])
    setOrDelete(body['phases']['hot']['actions']['rollover'], resource[:hot_rollover_max_docs.present?], 'max_docs', resource[:hot_rollover_max_docs])
    setOrDelete(body['phases']['hot']['actions']['rollover'], resource[:hot_rollover_max_age.present?], 'max_age', resource[:hot_rollover_max_age])
    setOrDelete(body['phases']['hot']['actions'], resource[:hot_unfollow], 'unfollow', {})
    setOrDelete(
      body['phases']['warm']['actions'],
      resource[:warm_allocate_number_of_replicas].present? || resource[:warm_allocate_include] || resource[:warm_allocate_exclude] || resource[:warm_allocate_require],
      'allocate',
      {}
    )
    setOrDelete(body['phases']['warm']['actions']['allocate'], resource[:warm_allocate_number_of_replicas.present?], 'number_of_replicas', resource[:warm_allocate_number_of_replicas])
    setOrDelete(body['phases']['warm']['actions']['allocate'], resource[:warm_allocate_include.present?], 'include', resource[:warm_allocate_include])
    setOrDelete(body['phases']['warm']['actions']['allocate'], resource[:warm_allocate_exclude.present?], 'exclude', resource[:warm_allocate_exclude])
    setOrDelete(body['phases']['warm']['actions']['allocate'], resource[:warm_allocate_require.present?], 'require', resource[:warm_allocate_require])
    setOrDelete(body['phases']['warm']['actions'], resource[:warm_read_only], 'readonly', {})
    setOrDelete(body['phases']['warm']['actions'], resource[:warm_force_merge_max_num_segments], 'forcemerge', {'max_num_segments' => resource[:warm_force_merge_max_num_segments]})
    setOrDelete(body['phases']['warm']['actions'], resource[:warm_shrink_number_of_shards], 'shrink', {'number_of_shards' => resource[:warm_shrink_number_of_shards]})
    setOrDelete(body['phases']['warm']['actions'], resource[:warm_unfollow], 'unfollow', {})
    setOrDelete(
      body['phases']['cold']['actions'],
      resource[:cold_allocate_number_of_replicas].present? || resource[:cold_allocate_include] || resource[:cold_allocate_exclude] || resource[:cold_allocate_require],
      'allocate',
      {}
    )
    setOrDelete(body['phases']['cold']['actions']['allocate'], resource[:cold_allocate_number_of_replicas.present?], 'number_of_replicas', resource[:cold_allocate_number_of_replicas])
    setOrDelete(body['phases']['cold']['actions']['allocate'], resource[:cold_allocate_include.present?], 'include', resource[:cold_allocate_include])
    setOrDelete(body['phases']['cold']['actions']['allocate'], resource[:cold_allocate_exclude.present?], 'exclude', resource[:cold_allocate_exclude])
    setOrDelete(body['phases']['cold']['actions']['allocate'], resource[:cold_allocate_require.present?], 'require', resource[:cold_allocate_require])
    setOrDelete(body['phases']['cold']['actions'], resource[:cold_freeze], 'freeze', {})
    setOrDelete(body['phases']['cold']['actions'], resource[:cold_unfollow], 'unfollow', {})
    setOrDelete(body['phases']['delete']['actions'], resource[:delete_delete], 'delete', {})
    JSON.generate(body)
  end

  private def setOrDelete(body_hash, conditional, key, value)
    if (conditional) body_hash[key] = value else body_hash.delete(key) end
  end
end
