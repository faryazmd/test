class jenkins::repo {

#jenkins repo

yumrepo { 
 "jenkins":
	baseurl => "http://pkg.jenkins-ci.org/redhat",
	descr => "jenkins repo",
	enabled => 1,
	gpgcheck => 1,
	gpgkey  => "http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key";
}

#sun java repo

$epel_rpm = 'epel-release-6-8.noarch.rpm'
file {"/opt/${epel_rpm}":
    ensure  => file,
    owner => root,
    group => root,
    mode => 0755,
    source => "puppet:///modules/jenkins/epel/${epel_rpm}",
}
#package {"epel":
#    provider => rpm,
#    ensure => installed,
#    source => "/opt/${epel_rpm}",
#}

#git repo
$rpmforge_rpm = 'rpmforge-release-0.5.2-2.el6.rf.i686.rpm'
file {
 "/etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL":
    ensure  => file,
    owner => root,
    group => root,
    mode => 0444,
    source => "puppet:///modules/jenkins/rpmforge/RPM-GPG-KEY.dag.txt";
 "/opt/${rpmforge_rpm}":
    ensure  => file,
    owner => root,
    group => root,
    mode => 0755,
    source => "puppet:///modules/jenkins/rpmforge/${rpmforge_rpm}"
}
package {"rpmforge":
    provider => rpm,
    ensure => installed,
    source => "/opt/${rpmforge_rpm}",
}
}
