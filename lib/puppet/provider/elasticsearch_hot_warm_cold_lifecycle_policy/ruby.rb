$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', '..'))

require 'puppet/provider/elastic_rest'

Puppet::Type.type(:elasticsearch_hot_warm_cold_lifecycle_policy).provide(
  :ruby,
  :parent => Puppet::Provider::ElasticREST,
  :api_uri => '_ilm/policy'
) do
  desc 'A REST API based provider to manage Elasticsearch hot-warm-cold lifecycle policy.'
  mk_resource_methods
  def self.process_body(body)
    #phases = JSON.parse(body)['policy']['phases']
    #coldPhasePresent = phases['cold'] != nil
    results =
      {
        :name                              => 'policy',
        :ensure                            => :present,
        :cold_min_age                      => '10d',
        #:cold_min_age                      => phases['cold']['min_age'],
        #:cold_allocate_require             => phases['cold']['actions']['allocate']['require'],
        :provider                          => name
      }
    results
  end

  def generate_body
    body = {
      'policy' => {
        'phases' => {
          'cold'   => {
            'min_age' => '10d'
          }
        }
      }
    }
    #body['phases']['cold']['min_age'] = 10
    #body['phases']['cold']['min_age'] = resource[:cold_min_age];
    #body['phases']['cold']['actions']['allocate'] = resource[:cold_allocate_require];
    #setOrDelete(body['phases']['cold']['min_age'], !resource[:cold_min_age].nil?, 'min_age', resource[:cold_min_age])
    #setOrDelete(body['phases']['cold']['actions']['allocate'], !resource[:cold_allocate_require].nil?, 'require', resource[:cold_allocate_require])
    JSON.generate(body)
  end

end
