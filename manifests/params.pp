# Class: postgresql::params
#
#   The postgresql configuration settings.
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class postgresql::params {
  $user                         = 'postgres'
  $group                        = 'postgres'
  $ip_mask_deny_postgres_user   = '0.0.0.0/0'
  $ip_mask_allow_all_users      = '127.0.0.1/32'
  $listen_addresses             = 'localhost'
  # TODO: figure out a way to make this not platform-specific
  $manage_redhat_firewall       = false

  case $::operatingsystem {
    "Ubuntu": {
      $service_provider = upstart
    }
    default: {
      $service_provider = undef
    }
  }

  case $::osfamily {
    'RedHat': {
      $service_name             = 'postgresql'
      $client_package_name      = 'postgresql'
      $server_package_name      = 'postgresql-server'
      $needs_initdb             = true
      $initdb_path              = '/usr/bin/initdb'
      $createdb_path            = '/usr/bin/createdb'
      $psql_path                = '/usr/bin/psql'
      $datadir                  = '/var/lib/pgsql/data/'
      $pg_hba_conf_path         = '/var/lib/pgsql/data/pg_hba.conf'
      $postgresql_conf_path     = '/var/lib/pgsql/data/postgresql.conf'
      $firewall_supported       = true
      $persist_firewall_command = '/sbin/iptables-save > /etc/sysconfig/iptables'
    }

    'Debian': {
      case $::operatingsystem {
        'Debian': {
            $service_name       = "postgresql"
        }

        'Ubuntu': {
            $service_name       = "postgresql-${::postgres_default_version}"
        }
      }

      $client_package_name      = 'postgresql-client'
      $server_package_name      = 'postgresql'
      $needs_initdb             = false
      $initdb_path              = "/usr/lib/postgresql/${::postgres_default_version}/bin/initdb"
      $createdb_path            = "/usr/lib/postgresql/${::postgres_default_version}/bin/createdb"
      $psql_path                = "/usr/lib/postgresql/${::postgres_default_version}/bin/psql"
      $datadir                  = "/var/lib/postgresql/${::postgres_default_version}/main"
      $pg_hba_conf_path         = "/etc/postgresql/${::postgres_default_version}/main/pg_hba.conf"
      $postgresql_conf_path     = "/etc/postgresql/${::postgres_default_version}/main/postgresql.conf"
      $firewall_supported       = false
      # TODO: not exactly sure yet what the right thing to do for Debian/Ubuntu is.
      #$persist_firewall_command = '/sbin/iptables-save > /etc/iptables/rules.v4'

    }


    default: {
      fail("Unsupported osfamily: ${::osfamily} operatingsystem: ${::operatingsystem}, module ${module_name} currently only supports osfamily RedHat and Debian")
    }
  }

}
