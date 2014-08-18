class jenkins::proxy{
$hostname = '$HOSTNAME'
package {
 ['httpd','mod_ssl','openssl']:
    ensure => latest,
}
exec {
 'openssl-genkey':
  command => 'openssl req -nodes -newkey rsa:2048 -keyout $HOSTNAME.key -out $HOSTNAME.csr -subj "/C=GB/ST=US/L=US/O=Global Security/OU=IT Department/CN=$HOSTNAME.com"',
  cwd => '/root',
   path => '/usr/bin';
 'openssl-cersign':
   command => 'openssl x509 -req -days 365 -in $HOSTNAME.csr -signkey $HOSTNAME.key -out $HOSTNAME.crt',  
   path => '/usr/bin',
   cwd => '/root',
   require => Exec["openssl-genkey"];
 'copy-cert':
   command => "/bin/cp -R ${hostname}.crt /etc/pki/tls/certs; /bin/cp -R ${hostname}.key /etc/pki/tls/private/${hostname}.key; /bin/cp -R ${hostname}.csr /etc/pki/tls/private/${hostname}.csr",
   cwd => '/root',
   path => '/bin',
   require => Exec["openssl-genkey","openssl-cersign"],
}
file {
 '/etc/httpd/conf.d/jenkins.conf':
  ensure => file,
  owner  => root,
  group  => root,
  content => template('jenkins/jenkins.conf.erb'),
  notify  => Service['jenkins','httpd'];
# '/etc/pki/tls/certs/': ensure => present, source => "/root/*.crt";
# '/etc/pki/tls/private/': ensure => present, source => ["/root/*.key","/root/*.csr"],
# '/etc/pki/tls/private/': ensure => present, source => "/root/*.csr",
}
service { "httpd":
    ensure  => "running",
    enable  => "true",
    require => Package["httpd"],
}
}
