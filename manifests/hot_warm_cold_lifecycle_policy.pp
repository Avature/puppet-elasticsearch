#  This define allows you to insert, update or delete Elasticsearch hot-warm-cold_freeze
#  lifecycle policy.
#
# @param ensure
#   Controls whether the named index template should be present or absent in
#   the cluster.
#
# @param api_basic_auth_password
#   HTTP basic auth password to use when communicating over the Elasticsearch
#   API.
#
# @param api_basic_auth_username
#   HTTP basic auth username to use when communicating over the Elasticsearch
#   API.
#
# @param api_ca_file
#   Path to a CA file which will be used to validate server certs when
#   communicating with the Elasticsearch API over HTTPS.
#
# @param api_ca_path
#   Path to a directory with CA files which will be used to validate server
#   certs when communicating with the Elasticsearch API over HTTPS.
#
# @param api_host
#   Host name or IP address of the ES instance to connect to.
#
# @param api_port
#   Port number of the ES instance to connect to
#
# @param api_protocol
#   Protocol that should be used to connect to the Elasticsearch API.
#
# @param api_timeout
#   Timeout period (in seconds) for the Elasticsearch API.
#
# @param hot_priority
#   The priority for the index. Must be 0 or greater. The value may also be set to null to remove the priority.
#
# @param hot_rollover_max_size
#   Max primary shard index storage size
#
# @param hot_rollover_max_docs
#   Max number of documents an index is to contain before rolling over
#
# @param hot_rollover_max_age
#   Max time elapsed from index creation
#
# @param hot_unfollow
#   This action turns a ccr follower index into a regular index
#
# @param warm_min_age
#   Indices enter phases based on a phase’s min_age parameter. The index will not enter the phase until the index’s age is older than that of the min_age
#
# @param warm_priority
#   The priority for the index. Must be 0 or greater. The value may also be set to null to remove the priority.
#
# @param warm_unfollow
#   This action turns a ccr follower index into a regular index
#
# @param warm_allocate_number_of_replicas
#   The number of replicas to assign to the index
#
# @param warm_allocate_include
#   Assigns an index to nodes having at least one of the attributes
#
# @param warm_allocate_exclude
#   Assigns an index to nodes having none of the attributes
#
# @param warm_allocate_require
#   Assigns an index to nodes having all of the attributes
#
# @param warm_read_only
#   This action will set the index to be read-only
#
# @param warm_force_merge_max_num_segments
#   The number of segments to merge to. To fully merge the index, set it to 1
#
# @param warm_shrink_number_of_shards
#   The number of shards to shrink to. must be a factor of the number of shards in the source index
#
# @param cold_min_age
#   Indices enter phases based on a phase’s min_age parameter. The index will not enter the phase until the index’s age is older than that of the min_age
#
# @param cold_priority
#   The priority for the index. Must be 0 or greater. The value may also be set to null to remove the priority.
#
# @param cold_allocate_number_of_replicas
#   The number of replicas to assign to the index
#
# @param cold_allocate_include
#   Assigns an index to nodes having at least one of the attributes
#
# @param cold_allocate_exclude
#   Assigns an index to nodes having none of the attributes
#
# @param cold_allocate_require
#   Assigns an index to nodes having all of the attributes
#
# @param cold_freeze
#   true if indexes should be deleted on cold phase
#
# @param cold_unfollow
#   This action turns a ccr follower index into a regular index
#
# @param delete_min_age
#   Indices enter phases based on a phase’s min_age parameter. The index will not enter the phase until the index’s age is older than that of the min_age
#
# @param delete_delete
#   true if the delete phase should delete indexes
#
# @author Gustavo Yoshizaki
define elasticsearch::hot_warm_cold_lifecycle_policy (
  Enum['absent', 'present']       $ensure                            = 'present',
  Optional[String]                $api_basic_auth_password           = $elasticsearch::api_basic_auth_password,
  Optional[String]                $api_basic_auth_username           = $elasticsearch::api_basic_auth_username,
  Optional[Stdlib::Absolutepath]  $api_ca_file                       = $elasticsearch::api_ca_file,
  Optional[Stdlib::Absolutepath]  $api_ca_path                       = $elasticsearch::api_ca_path,
  String                          $api_host                          = $elasticsearch::api_host,
  Integer[0, 65535]               $api_port                          = $elasticsearch::api_port,
  Enum['http', 'https']           $api_protocol                      = $elasticsearch::api_protocol,
  Integer                         $api_timeout                       = $elasticsearch::api_timeout,
  Boolean                         $validate_tls                      = $elasticsearch::validate_tls,
  Optional[Integer]               $hot_priority                      = undef,
  Optional[Integer]               $hot_rollover_max_size             = undef,
  Optional[Integer]               $hot_rollover_max_docs             = undef,
  Optional[Integer]               $hot_rollover_max_age              = undef,
  Optional[Boolean]               $hot_unfollow                      = undef,
  Optional[Integer]               $warm_min_age                      = undef,
  Optional[Integer]               $warm_priority                     = undef,
  Optional[Boolean]               $warm_unfollow                     = undef,
  Optional[Integer]               $warm_allocate_number_of_replicas  = undef,
  Optional[Hash]                  $warm_allocate_include             = undef,
  Optional[Hash]                  $warm_allocate_exclude             = undef,
  Optional[Hash]                  $warm_allocate_require             = undef,
  Optional[Boolean]               $warm_read_only                    = undef,
  Optional[Integer]               $warm_force_merge_max_num_segments = undef,
  Optional[Integer]               $warm_shrink_number_of_shards      = undef,
  Optional[Integer]               $cold_min_age                      = undef,
  Optional[Integer]               $cold_priority                     = undef,
  Optional[Integer]               $cold_allocate_number_of_replicas  = undef,
  Optional[Hash]                  $cold_allocate_include             = undef,
  Optional[Hash]                  $cold_allocate_exclude             = undef,
  Optional[Hash]                  $cold_allocate_require             = undef,
  Optional[Boolean]               $cold_freeze                       = undef,
  Optional[Boolean]               $cold_unfollow                     = undef,
  Optional[Integer]               $delete_min_age                    = undef,
  Optional[Boolean]               $delete_delete                     = undef,
  ) {
  es_instance_conn_validator { "${name}-hot-warm-cold_lifecycle_policy":
    server  => $api_host,
    port    => $api_port,
    timeout => $api_timeout,
  }
  -> elasticsearch_hot_warm_cold_lifecycle_policy { $name:
    ensure                            => $ensure,
    hot_priority                      => $hot_priority,
    hot_rollover_max_size             => $hot_rollover_max_size,
    hot_rollover_max_docs             => $hot_rollover_max_docs,
    hot_rollover_max_age              => $hot_rollover_max_age,
    hot_unfollow                      => $hot_unfollow,
    warm_min_age                      => $warm_min_age,
    warm_priority                     => $warm_priority,
    warm_unfollow                     => $warm_unfollow,
    warm_allocate_number_of_replicas  => $warm_allocate_number_of_replicas,
    warm_allocate_include             => $warm_allocate_include,
    warm_allocate_exclude             => $warm_allocate_exclude,
    warm_allocate_require             => $warm_allocate_require,
    warm_read_only                    => $warm_read_only,
    warm_force_merge_max_num_segments => $warm_force_merge_max_num_segments,
    warm_shrink_number_of_shards      => $warm_shrink_number_of_shards,
    cold_min_age                      => $cold_min_age,
    cold_priority                     => $cold_priority,
    cold_allocate_number_of_replicas  => $cold_allocate_number_of_replicas,
    cold_allocate_include             => $cold_allocate_include,
    cold_allocate_exclude             => $cold_allocate_exclude,
    cold_allocate_require             => $cold_allocate_require,
    cold_freeze                       => $cold_freeze,
    cold_unfollow                     => $cold_unfollow,
    delete_min_age                    => $delete_min_age,
    delete_delete                     => $delete_delete,
    protocol                          => $api_protocol,
    host                              => $api_host,
    port                              => $api_port,
    timeout                           => $api_timeout,
    username                          => $api_basic_auth_username,
    password                          => $api_basic_auth_password,
    ca_file                           => $api_ca_file,
    ca_path                           => $api_ca_path,
    validate_tls                      => $validate_tls,
  }
}
