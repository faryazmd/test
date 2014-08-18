class jenkins::slave
{
$swarm_client = 'swarm-client-1.16-jar-with-dependencies.jar'
file {"/opt/${swarm_client}":
    ensure => file,
    owner => root,
    group => root,
    mode => 0755,
    source => "puppet:///modules/jenkins/${swarm_client}",
}
exec {"swarm_autodiscover":
    command => "java -jar ${swarm_client} -disableSslVerification -master https://testbuild02.puppettest.com/ -username admin -password admin123",
    cwd => "/opt",
    path => "/usr/bin",
    timeout => "1800",
    logoutput => "true",
    require => File["/opt/${swarm_client}"],
}
}
