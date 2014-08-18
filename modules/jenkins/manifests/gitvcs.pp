class jenkins::gitvcs
{
exec {
 "git-user":
    command => "git config --global user.name 'Mohammed Faryaz'", 
#    cwd => "/var/lib/jenkins/users",
    path => "/usr/local/bin",
}
}
