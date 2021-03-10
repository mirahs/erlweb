#!/bin/bash
export PATH=/d/apps/erl9.3/bin:${PATH}


DIR_ROOT=$(dirname $(readlink -f $0))/


fun_make()
{
	cd ${DIR_ROOT}
	rm -rf ebin
    ./rebar g-d
    ./rebar co
}

fun_start()
{
    cd ${DIR_ROOT}

    #erl -pa deps/*/ebin ebin -boot start_clean +P 1024000 -s main start
    werl -pa deps/*/ebin ebin -boot start_clean +P 1024000 -s main start &
}


fun_help()
{
    echo "make           		编译"
	echo "start                 启动"

    exit 1
}



if [ $# -eq 0 ]
then
	fun_help
else
	fun_$1 $*
fi

exit 0
