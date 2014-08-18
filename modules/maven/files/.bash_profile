# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
        . ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/bin:/opt/apache-maven-3.2.2/bin
JAVA_HOME=/usr/java/jdk1.8.0_11

export PATH
export JAVA_HOME

