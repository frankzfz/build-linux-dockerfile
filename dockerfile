FROM dadoha/centos7.4.1708:latest 

RUN yum -y groupinstall 'Development Tools' 
RUN yum -y install git rpm rpm-build rpmdevtools rng-tools 
RUN yum -y install xmlto asciidoc elfutils-libelf-devel zlib-devel 
RUN yum -y install binutils-devel newt-devel python-devel numactl-devel 
RUN yum -y install perl-ExtUtils-Embed 
RUN yum -y install hmaccalc 
RUN yum -y install audit-libs-devel binutils-devel elfutils-devel elfutils-libelf-development 
RUN yum -y install redhat-rpm-config patchutils bison 
RUN yum -y install hostname net-tools
RUN yum -y install module-init-tools bc openssl  openssl-devel 
RUN yum -y install centos-release-scl
RUN yum -y install devtoolset-11-gcc devtoolset-11-gcc-c++
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum -y install  dwarves
RUN echo "source /opt/rh/devtoolset-11/enable"  >> /etc/bashrc
RUN yum -y install python3
ADD dwarves-1.17-1.el7.x86_64.rpm  / 
ADD libdwarves1-1.17-1.el7.x86_64.rpm  /
ADD libdwarves1-devel-1.17-1.el7.x86_64.rpm /
RUN rpm -ivh --force dwarves-1.17-1.el7.x86_64.rpm  libdwarves1-1.17-1.el7.x86_64.rpm libdwarves1-devel-1.17-1.el7.x86_64.rpm 
RUN source /etc/bashrc
CMD ["/bin/bash"]
