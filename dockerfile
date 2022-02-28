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
RUN echo "source /opt/rh/devtoolset-11/enable"  >> /etc/bashrc
RUN source /etc/bashrc
CMD ["/bin/bash"]
