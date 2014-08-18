#!/bin/bash


function pkg_preconfigure() {
### Store any build specific values in this function

    . /etc/profile.d/rbenv.sh

    # grab el version by tokenizing rpm -q centos-release
    # should be of form "centos-release-6-4.el6.centos.10.x86_64"
    # thereby making the second token valuable
    OS_VERSION=$(expr $(uname -r) : '.*\(el[0-9]*\)' )

    ARCH=$(uname -p)

    # Grab this scripts location
    SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    # NSS lib version
    NSS_VERSION="3.16.3"

    # NSPR version (refers to what the nss lib was built with when fetching)
    NSPR_VERSION="4.10.6"

    # Fetch Version:
    ## Version of the rpm package as it is called when you try to wget it
    ## Can be found on the actual uri called on the oracle dload page:
    # Example:
    ## http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm
    ##                                             ^ here ^
    JDK_FETCH_VERSION="7u60-b19"

    # JDK Version:
    ## Version of JDK as it's called after you install it or run java -version
    JDK_VERSION="1.7.0_60"

    # Version referring to our packaging or patch revision
    JDK_ITERATION=1

    JDK_DESCRIPTION="JDK ${JDK_VERSION} repackaged to install to /opt and including 2 security jars"

}

function pkg_prepare() {
    ### Install any dependencies here!
    yum install -y gcc make eg-ruby wget rpm-build

    if [[ $OS_VERSION = "el5" ]]; then
        yum install gcc44 binutils220
    fi

    . /etc/profile.d/rbenv.sh
    # Install fpm with any available ruby version
    gem install fpm --no-rdoc --no-ri
}

function pkg_configure() {
    mkdir -p $SCRIPT_DIR/src
    mkdir -p $SCRIPT_DIR/build
    cd $SCRIPT_DIR/src

    # we need the new binutils for NSS
    if [[ $OS_VERSION = "el5" ]]; then
        export PATH=/usr/libexec/binutils220:$PATH
    fi

    # Security jars are versionless and just associated with a major release
    wget --no-cookies \
    --header "Cookie: s_cc=true; oraclelicense=accept-securebackup-cookie; s_nr=1405373639124; gpw_e24=http%3A%2F%2Fwww.oracle.com%2Ftechnetwork%2Fjava%2Fjavase%2Fdownloads%2Fjce-7-download-432124.html; s_sq=%5B%5BB%5D%5D" \
    "http://download.oracle.com/otn-pub/java/jce/7/UnlimitedJCEPolicyJDK7.zip" \
    --no-check-certificate \
    -O security_jars.zip

    wget --no-cookies \
    --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com; oraclelicense=accept-securebackup-cookie" \
    "http://download.oracle.com/otn-pub/java/jdk/$JDK_FETCH_VERSION/jdk-${JDK_FETCH_VERSION/-b[0-9]*?/}-linux-x64.rpm" \
    --no-check-certificate \
    -O jdk-$JDK_VERSION.rpm

    wget "http://ftp.mozilla.org/pub/mozilla.org/security/nss/releases/NSS_${NSS_VERSION//\./_}_RTM/src/nss-${NSS_VERSION}-with-nspr-${NSPR_VERSION}.tar.gz" \
    --no-check-certificate \
    -O nss-libs.tar.gz
}

function pkg_build() {
    rpm -i $SCRIPT_DIR/src/jdk-$JDK_VERSION.rpm --prefix=$SCRIPT_DIR/build/opt/jdk
    mv $SCRIPT_DIR/build/opt/jdk/jdk$JDK_VERSION $SCRIPT_DIR/build/opt/jdk/$JDK_VERSION-$JDK_ITERATION

    cd $SCRIPT_DIR/src

    # unpack and copy over security jars
    unzip $SCRIPT_DIR/src/security_jars.zip
    cp -f $SCRIPT_DIR/*.jar $SCRIPT_DIR/build/opt/jdk/$JDK_VERSION-$JDK_ITERATION/lib/security/

    # Add in the nss lib
    tar -xzf $SCRIPT_DIR/src/nss-libs.tar.gz
    cd nss-$NSS_VERSION/nss
    make BUILD_OPT=1 USE_64=1 NO_AVX=1 nss_build_all
    cp -L $SCRIPT_DIR/src/nss-$NSS_VERSION/dist/Linux*/lib/* $SCRIPT_DIR/build/opt/jdk/$JDK_VERSION-$JDK_ITERATION/jre/lib

    #Create post-install script for jdk link
    echo "#!/bin/bash
    if [ ! -h '/opt/jdk/current' ]; then
      ln -s /opt/jdk/$JDK_VERSION-$JDK_ITERATION /opt/jdk/current
    fi

    if [ -h '/opt/jdk/latest' ]; then
      rm -f /opt/jdk/latest
    fi
    ln -s /opt/jdk/$JDK_VERSION-$JDK_ITERATION /opt/jdk/latest" > $SCRIPT_DIR/post-install.sh
    chmod +x $SCRIPT_DIR/post-install.sh
}

function pkg_package() {
    # This is the packaging meat!

    mkdir -p $SCRIPT_DIR/dist
    cd $SCRIPT_DIR/dist

    fpm -s dir -t rpm  \
        --version "$JDK_VERSION" \
        --architecture $ARCH \
        --iteration "$JDK_ITERATION" \
        --rpm-rpmbuild-define "dist .${OS_VERSION}" \
        --rpm-rpmbuild-define "rhel ${OS_VERSION##el}" \
        --rpm-rpmbuild-define "${OS_VERSION} 1" \
        --url "http://egnyte.com" \
        --vendor ops@egnyte.com \
        --maintainer ops@egnyte.com  \
        --description "$JDK_DESCRIPTION" \
        --name eg-jdk \
        --provides eg-jdk \
        --provides jdk \
        --after-install "$SCRIPT_DIR/post-install.sh" \
        -C $SCRIPT_DIR/build \
        --package eg-jdk-$JDK_VERSION-$JDK_ITERATION.$OS_VERSION.$ARCH.rpm \
        opt/jdk/$JDK_VERSION-$JDK_ITERATION

}

function pkg_default() {
    pkg_prepare

    # Eval this to get the conf env in this shell
    eval pkg_preconfigure

    pkg_configure
    pkg_build
    pkg_package
}


if [[ $# -eq 0 ]]; then
    pkg_default
fi


