#
# pffffffffffffffffffff
class ssh::install {
  # adding comment
  package { 'openssh-server':
    ensure => present,
  }
}
