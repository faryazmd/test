class jenkins::jobbuilder
{
$jobbuilder_archive = 'jenkins-job-builder-0.8.1.tar.gz'
package {["python-setuptools","unzip"]: ensure => installed,}
exec {
 "jobbuilder_extracter":
    command      => "tar xvzf ${jobbuilder_archive}",
    cwd          => "/opt",
    path         => ['/bin','/usr/bin','/usr/sbin','/usr/local/bin'],
    require  => [File["/opt/${jobbuilder_archive}"],Package["unzip"]];
 "dep_installer":
    command => "easy_install pip && easy_install argparse && easy_install six",
    path    => ['/bin','/usr/bin','/usr/sbin','/usr/local/bin'];
 "jobbuilder_installer":
    command => "python setup.py install",
    cwd => "/opt/jenkins-job-builder-0.8.1",
     path => "/usr/bin",
    require => Exec["jobbuilder_extracter","dep_installer"],
}
file {
 "/opt/${jobbuilder_archive}":
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '0755',
    source => "puppet:///modules/jenkins/${jobbuilder_archive}";
 "/etc/jenkins_jobs":
    ensure => directory,
    owner  => root,
    group  => root;
"/etc/jenkins_jobs/jenkins_jobs.ini":
  ensure => file,
  owner  => root,
  group  => root,
  content => template('jenkins/jenkins_jobs.ini.erb'),
  }
}

