#!/bin/bash

function usage(){
    if [ $# -ne 1 ]
    then
        echo "**********************************"
        echo Usage: build_kernel.sh need 1 parameter,linux version ex:5.6 5.15 ...
        echo "**********************************"
        exit 0
    fi
}

  #git rev-parse --git-dir 2> /dev/null;


#if  test -z "$(git rev-parse --git-dir)";then #-n len =0  true  -z len>0 true
   # git clone  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
#else
#    echo "linux-stable exting  no need git clone"
#fi

function check_linux_stable_git_repo {
    if [ -d .git ];then
        rev=$(git remote -v 2>/dev/null)
        if [ $? -eq 0 ];then
            rev=$(echo $rev | grep -w "linux-stable")
            if test -n "$rev"; then
                echo "linux-stable git repo"
                return;
            else
                echo "no linux-stable git repo!!"
            fi
        fi
    else
        echo "no  git  repo! please linux-stable git repo"
        exit 0
    fi
}
function check_linux_stable_repo {
    if [ -d .git ] && [ -d linux-stable ];then
        cd $PWD/linux-stable
        check_linux_stable_git_repo
    else
        if [ -d linux-stable ];then
            cd $PWD/linux-stable
            check_linux_stable_git_repo
        else
            echo " .git no  linux-stable git repo need clone!"
            git clone  git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
            cd $PWD/linux-stable
        fi
    fi

    linux_version=$(git branch -r| awk -F  origin/linux- '{print $2}' | awk -F .y '{print $1}')
    #len=$(echo ${linux_version} | awk  '{print length($0)}')
    len_1=$(echo ${linux_version} | awk -F "" '{print NF}')
    for version in $linux_version
    do
        if [ "$1" != "$version" ];then
            len=$[len+1]
            if [ $len -eq $len_1 ];then
                echo "Error $version is not belong linux version!! "
                exit 0
            fi
            continue
        else
            echo "$version is correct linux version"
        fi
    done
}

function GetBranch {
	if test -z "$(git rev-parse --show-cdup 2>/dev/null)" &&  head=$(git rev-parse --verify HEAD 2>/dev/null); then
		branch_name=$(git rev-parse --abbrev-ref HEAD)
		if [ "$branch_name" != "$1" ]; then
			echo  "$#  $* $1"
			git checkout -f -B $1 origin/linux-$1.y 2>/dev/null
			if [ $? -eq 0 ]
			then
				echo "get linux branch success! linux version $1"
			else
				echo $PWD
				echo "Error:please check linux version!"
				exit 1
			fi
		fi
		echo -e "current branch  $(git rev-parse --abbrev-ref HEAD)"
	fi
}

function setlocalversion {
    localversion=localversion
    separator="."
    if [ -f localversion ]
    then
        echo "OK localversion is a version file"
        cat localversion
    else
        echo -e "localversion not exist,create localversion"
        touch localversion
        echo -n " Enter linux build version:"
        read version
        version=$separator$version
        echo $version >> localversion
    fi
}

function build_kernel() {

     usage $1
     check_linux_stable_repo $1
	 echo $PWD
     GetBranch $1
     setlocalversion

       if [ -f $PWD/arch/x86/configs/x86_64_defconfig.back ]
       then
        echo "x86_64_defconfig.back exsting!!"
       else
            mv $PWD/arch/x86/configs/x86_64_defconfig $PWD/arch/x86/configs/x86_64_defconfig.back
       fi
        cp ../frankzfz.config $PWD/arch/x86/configs/x86_64_defconfig
        if [ -f $PWD/.config ];then
            rm -rf $PWD/.config
        fi

        make olddefconfig
        make LOCALVERSION= rpm-pkg -j4 V=s 2>&1 | tee build.log

    copy_rpm_package $1
}

function copy_rpm_package() {

    source_dir=/root/rpmbuild/RPMS/x86_64
    target_dir=$PWD
    echo "work dir $PWD"
	if [ -d $target_dir/package ];then
        cd $source_dir
        cp -v `ls | grep $1 `  $target_dir/package
	else
        echo "create rpm package dir"
		mkdir $target_dir/package
        cd $source_dir
        cp -v  $source_dir/`ls $source_dir |  grep  $1`  $target_dir/package
	fi
    cd $source_dir
}

build_kernel $1
