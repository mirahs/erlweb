#!/bin/bash
export PATH=/d/apps/erl9.3/bin:${PATH}


DIR_ROOT=$(dirname $(readlink -f $0))/

BEAM="deps/*/ebin ebin"


fun_dev()
{
	cd ${DIR_ROOT}
	rm -rf ebin
	./rebar g-d
	./rebar -D debug co

	echo 编译模板开始
	erl -pa ${BEAM} -noshell -s erlweb_make_dtl -s c q -extra ./src/web/view ./ebin web_erlydtl_tag
	echo 编译模板完成
}

fun_rel()
{
	cd ${DIR_ROOT}
	rm -rf ebin
	./rebar g-d
	./rebar co

	echo 编译模板开始
    erl -pa ${BEAM} -noshell -s erlweb_make_dtl -s c q -extra ./src/web/view ./ebin web_erlydtl_tag
    echo 编译模板完成
}


fun_start()
{
    cd ${DIR_ROOT}

    dirVar='var/'
    mkdir -p ${dirVar}

    werl -pa ${BEAM} -name admin@127.0.0.1 -config ./elog +P 1024000 -s main start -extra ${dirVar} &
}

fun_stop()
{
    cd ${DIR_ROOT}

    erl -pa ${BEAM} -name admin_stop@127.0.0.1 -noshell -eval "rpc:call('admin@127.0.0.1', main, stop, []), erlang:halt()."
}


fun_help()
{
    echo "dev           		开发版"
    echo "rel                   正式版"

	echo "start                 启动服务器"
	echo "stop                  关闭服务器"

    exit 1
}



if [ $# -eq 0 ]
then
	fun_help
else
	fun_$1 $*
fi

exit 0
