class nexus::proxy{
$hostname = '$HOSTNAME'
package {
 ['httpd','mod_ssl','openssl']:
    ensure => latest,
}
exec {
 'openssl-genkey':
  command => 'openssl req -nodes -newkey rsa:2048 -keyout $HOSTNAME.key -out $HOSTNAME.csr -subj "/C=GB/ST=US/L=US/O=Global Security/OU=IT Department/CN=$HOSTNAME"',
  cwd => '/root',
   path => '/usr/bin',
   require => Package["openssl"];
 'openssl-cersign':
   command => 'openssl x509 -req -days 365 -in $HOSTNAME.csr -signkey $HOSTNAME.key -out $HOSTNAME.crt',  
   path => '/usr/bin',
   cwd => '/root',
   require => [Exec["openssl-genkey"],Package["openssl"]];
 'copy-cert':
   command => "/bin/cp -R ${hostname}.crt /etc/pki/tls/certs; /bin/cp -R ${hostname}.key /etc/pki/tls/private/${hostname}.key; /bin/cp -R ${hostname}.csr /etc/pki/tls/private/${hostname}.csr",
   cwd => '/root',
   path => '/bin',
   require => [Exec["openssl-genkey","openssl-cersign"],Package["openssl"]],
}
file {
 '/etc/httpd/conf.d/nexus.conf':
  ensure => file,
  owner  => root,
  group  => root,
  content => template('nexus/nexus.conf.erb'),
  require => Package["httpd"],
  notify  => Service['nexus','httpd'];
 '/etc/httpd/conf.d/ssl.conf':
  ensure => file,
  owner  => root,
  group  => root,
  content => template('nexus/ssl.conf.erb'),
  require => Package["httpd"],
  notify  => Service['nexus','httpd'];
}
service { "httpd":
    ensure  => "running",
    enable  => "true",
    require => Package["httpd"],
}
}
