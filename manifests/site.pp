## site.pp ##

# This file (./manifests/site.pp) is the main entry point
# used when an agent connects to a master and asks for an updated configuration.
# https://puppet.com/docs/puppet/latest/dirs_manifest.html
#
# Global objects like filebuckets and resource defaults should go in this file,
# as should the default node definition if you want to use it.

## Active Configurations ##

# Disable filebucket by default for all File resources:
# https://github.com/puppetlabs/docs-archive/blob/master/pe/2015.3/release_notes.markdown#filebucket-resource-no-longer-created-by-default
File { backup => false }

## Node Definitions ##

# The default node definition matches any node lacking a more specific node
# definition. If there are no other node definitions in this file, classes
# and resources declared in the default node definition will be included in
# every node's catalog.
#
# Note that node definitions in this file are merged with node data from the
# Puppet Enterprise console and External Node Classifiers (ENC's).
#
# For more on node definitions, see: https://puppet.com/docs/puppet/latest/lang_node_definitions.html
node default {
  # This is where you can declare classes for all nodes.
  # Example:
  include docker
  class { 'hdm':
    hostname => $facts['hostname'],
    version =>  '1.0.1'
  }  

  class { 'hiera':
  hiera_version        => '5',
  hiera5_defaults      =>  {"datadir" => "data", "data_hash" => "yaml_data"},
  hierarchy            => [
                                "name" =>  "Example yaml", 
                                "paths" =>  ['roles/%{trusted.extensions.pe_role}.eyaml', 'roles/%{trusted.extensions.pp_role}.eyaml', 'os/%{facts.os.family}.eyaml', 'common.yaml' ],
                                "lookup_key" => 'eyaml_lookup_key',
                                "options"=> {
                                  "pkcs7_private_key" => '/etc/puppetlabs/puppet/keys/private_key.pkcs7.pem',
                                  "pkcs7_public_key"  => '/etc/puppetlabs/puppet/keys/public_key.pkcs7.pem',
                                  "gpg_gnupghome"     => '/etc/puppetlabs/puppet/keys/gpg',
                                  }
                           ],
  eyaml                => true,
  eyaml_gpg            => true,
  eyaml_gpg_recipients => 'lab@example.com,david@example.com,someone@example.com',
  }
}
