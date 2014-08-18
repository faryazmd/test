class maven::install {
$maven_archive = 'apache-maven-3.2.2-bin.tar.gz'
file {
 "$maven_archive":
      ensure  =>  file,
      path    =>  "/opt/${maven_archive}",
      notify  =>  Exec['maven_installer'],
      source  =>  "puppet:///modules/maven/${maven_archive}";
 "/root/.bash_profile":
      ensure => file,
      source  =>  "puppet:///modules/maven/.bash_profile",
      notify  =>  Exec['maven_path'],
}
exec {
 "maven_installer":
        command      => "tar -xzvf ${maven_archive}",
        cwd          => "/opt",
        refreshonly  => true,
        path         => ['/bin','/usr/bin','/usr/sbin','/usr/local/bin'];
 "maven_path":
        command => "bash -c 'source .bash_profile'",
        path      => '/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin',
        logoutput   => true,
}
}
