class jenkins::config{
file {
 "/var/lib/jenkins/config.xml":
  ensure => file,
  owner  => jenkins,
  group  => jenkins,
  content => template('jenkins/config.xml.erb'),
  require => Package["jenkins"],
  notify  => Service['jenkins','httpd'];
"/var/lib/jenkins/hudson.tasks.Maven.xml":
  ensure => file,
  owner  => jenkins,
  group  => jenkins,
  content => template('jenkins/hudson.tasks.Maven.xml.erb'),
  require => Package["jenkins"],
  notify  => Service['jenkins','httpd'];
"/var/lib/jenkins/jenkins.model.JenkinsLocationConfiguration.xml":
  ensure => file,
  owner  => jenkins,
  group  => jenkins,
  content => template('jenkins/jenkins.model.JenkinsLocationConfiguration.xml.erb'),
  require => Package["jenkins"],
  notify  => Service['jenkins','httpd'];
"/var/lib/jenkins/hudson.plugins.git.GitTool.xml":
  ensure => file,
  owner  => jenkins,
  group  => jenkins,
  content => template('jenkins/hudson.plugins.git.GitTool.xml.erb'),
  require => Package["jenkins"],
  notify  => Service['jenkins','httpd'];
"/var/lib/jenkins/users":
    ensure    => directory,
    owner     => 'jenkins',
    group     => 'jenkins',
    source    => 'puppet:///modules/jenkins/users',
    recurse   => true,
    notify    => Service["jenkins"],
    require   => Package["jenkins"];
}
}


