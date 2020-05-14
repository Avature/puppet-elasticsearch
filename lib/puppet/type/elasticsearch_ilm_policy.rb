$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..'))

require 'puppet/file_serving/content'
require 'puppet/file_serving/metadata'

require 'puppet_x/elastic/deep_implode'
require 'puppet_x/elastic/deep_to_i'
require 'puppet_x/elastic/deep_to_s'
require 'puppet_x/elastic/elasticsearch_rest_resource'

Puppet::Type.newtype(:elasticsearch_ilm_policy) do
  extend ElasticsearchRESTResource

  desc 'Manages Elasticsearch ILM policies.'

  ensurable

  newparam(:name, :namevar => true) do
    desc 'ILM policy name.'
  end

  newproperty(:content) do
    desc 'Structured content of template.'

    validate do |value|
      raise Puppet::Error, 'hash expected' unless value.is_a? Hash
    end

    def insync?(is)
      Puppet_X::Elastic.deep_implode(is) == \
        Puppet_X::Elastic.deep_implode(should)
    end
  end

  # rubocop:disable Style/SignalException
  validate do
    # Ensure that at least one source of template content has been provided
    if self[:ensure] == :present
      fail Puppet::ParseError, '"content" required' if self[:content].nil?
    end

  end
end # of newtype
