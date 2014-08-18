class nexus::install
{
$jdk_rpm = 'jdk-8u11-linux-x64.rpm'
$nexus_archive = 'nexus-2.8.1-01-bundle.tar.gz'
file {
 "/opt/${jdk_rpm}":
      ensure  =>  file,
      source  =>  "puppet:///modules/nexus/${jdk_rpm}";
 #"/usr/local/${nexus_archive}":
 "/opt/${nexus_archive}":
      ensure  =>  file,
#      owner => "nexus",
#      group => "nexus",
      source  =>  "puppet:///modules/nexus/${nexus_archive}";
# "/etc/init.d/nexus":
#      ensure => "/usr/local/nexus-2.8.1-01/bin/nexus",
#      owner  => nexus,
#      group  => nexus,
#      content => template('nexus/nexus.erb'),
#      notify  => Service["nexus"],
#       require => File["/usr/local/nexus-2.8.1-01/bin/nexus"];
# "/usr/local/nexus-2.8.1-01/bin/nexus":
 "/opt/nexus-2.8.1-01/bin/nexus":
     ensure => file,
#     owner  => nexus,
#     group  => nexus,
#     source  =>  "puppet:///modules/nexus/nexus",
     content => template('nexus/nexus.erb'),
     require => [Package["jdk_8"],Exec["nexus_extracter"]],
#     notify  => Service["nexus"],
}
#service { "nexus":
#    ensure  => "running",
#    enable  => "true",
#    require => File["/etc/init.d/nexus"],
#}
#if ! Package["jdk-1.8.0_11-fcs.x86_64"]{
package {
 "jdk_8":
    provider => rpm,
    ensure => installed,
    source => "/opt/${jdk_rpm}",
    require => File["/opt/${jdk_rpm}"];
 "createrepo":
   ensure => installed,
}
#}
#user { 
# "nexus":
#   ensure => 'present',
#}
exec {
 "nexus_extracter":
    cwd => "/opt",
command => "tar xvzf ${nexus_archive}",
#    command => "tar xvzf ${nexus_archive} && chown -R nexus:nexus nexus-2.8.1-01",
    path => "/bin",
    require => File["/opt/${nexus_archive}"],
}
}
