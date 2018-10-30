# Demonstrate how to use the Sensitive data type
#
# @summary Demonstrate how to use the Sensitive data type
#
# @example
#   $pw = Sensitive('my_password')
#
#   class { demo_sensitive_puppet:
#     password => $pw,
#   }
#
class demo_sensitive_puppet (
  Sensitive[String[1]] $password,
) {
  notify { 'Wrapped Password':
    message => $password,
    before  => File['secrets_file'],
  }

  $secrets_file = $facts['os']['family'] ? {
    'windows' => 'C:/secrets_file',
    default   => '/tmp/secrets_file',
  }

  file { 'secrets_file':
    ensure  => file,
    path    => $secrets_file,
    content => unwrap($password),
  }
}
