class jenkins::install
{
$jenkins_cli = 'jenkins-cli.jar'
$jenkins_plugin = '/var/lib/jenkins/plugins'
$git_archive = 'git-2.0.1.tar.gz'
$jdk_rpm = 'jdk-8u11-linux-x64.rpm'

package {
 ['jenkins',"Development tools"]:
  ensure => latest,
    notify => Service["jenkins"];
 ['expat-devel','gettext-devel','openssl-devel','zlib-devel','gcc','perl-ExtUtils-MakeMaker']:
    ensure => latest;
"jdk_8":
    provider => rpm,
    ensure => installed,
    source => "/opt/${jdk_rpm}",
    require => File["/opt/${jdk_rpm}"],
}
exec {
 "git_extracter":
    command      => "tar xzf ${git_archive}",
    cwd          => "/opt",
    path         => ['/bin','/usr/bin','/usr/sbin','/usr/local/bin'],
    require  => File["/opt/${git_archive}"];
"git_installer":
    cwd => "/opt/git-2.0.1",
    command => "/opt/git-2.0.1/configure && make && make install",
    timeout     => 1800,
    require  => File["/opt/${git_archive}"],
}       
service { 
 "jenkins":
    ensure  => "running",
    enable  => "true",
    require => Package["jenkins"],
}
file {
 "/opt/${jdk_rpm}":
      ensure  =>  file,
      source  =>  "puppet:///modules/nexus/${jdk_rpm}";
 "/opt/${jenkins_cli}":
     ensure => present,
     owner => 'root',
     group => 'root',
     mode => '0755',
     source => "puppet:///modules/jenkins/${jenkins_cli}";
 "${jenkins_plugin}":
    ensure    => directory,
    owner     => 'jenkins',
    group     => 'jenkins',
    source    => 'puppet:///modules/jenkins/plugins',
    recurse   => true,
    notify    => Service["jenkins"],
    require   => Package["jenkins"];
 "/opt/${git_archive}":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '0755',
   source => "puppet:///modules/jenkins/${git_archive}";
}
}
