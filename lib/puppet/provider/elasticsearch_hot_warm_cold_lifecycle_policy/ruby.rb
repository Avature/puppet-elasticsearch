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
    coldPhasePresent = phases['cold'] != nil
    results =
      {
        :name                              => 'policy',
        :ensure                            => :present,
        :cold_min_age                      => if !coldPhasePresent then nil else phases['cold']['min_age'] end,
        :cold_allocate_require             => if !coldPhasePresent || phases['cold']['actions']['allocate'].nil? then nil else phases['cold']['actions']['allocate']['require'] end,
        :provider                          => name
      }
    results
  end

  def generate_body
    body = {
      'phases' => {
        'cold'   => {
          'actions' => {
          }
        }
      }
    }
    setOrDelete(
      body['phases']['cold']['actions'],
      !resource[:cold_allocate_require].nil?,
      'allocate',
      {}
    )
    setOrDelete(body['phases']['cold']['min_age'], !resource[:cold_min_age].nil?, 'min_age', resource[:cold_min_age])
    setOrDelete(body['phases']['cold']['actions']['allocate'], !resource[:cold_allocate_require].nil?, 'require', resource[:cold_allocate_require])
    JSON.generate(body)
  end

  private def setOrDelete(body_hash, conditional, key, value)
    if conditional then
      body_hash[key] = value
    else
      body_hash.delete(key)
    end
  end
end
