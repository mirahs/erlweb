-module(web_erlydtl_tag).

-compile(nowarn_export_all).
-compile(export_all).

-include("common.hrl").


%% 格式化时间
ymdhis([Seconds]) when is_integer(Seconds) andalso Seconds > 0 ->
	date_YmdHis(Seconds);
ymdhis(_) ->
	"1970-01-01 00:00:00".

ymd([Seconds]) when is_integer(Seconds) andalso Seconds > 0 ->
	util:date_YmdE(Seconds);
ymd(_) ->
	"1970-01-01".


%%----------------------------------------------------
%% 内部函数
%%----------------------------------------------------
date_YmdHis(Seconds) ->
	{{Y,M,D}, {H,I,S}} = util:seconds2localtime(Seconds),
	util:to_list(Y) ++ "-" ++ util:date_format(M) ++ "-" ++ util:date_format(D) ++ " " ++ util:date_format(H) ++ ":" ++  util:date_format(I) ++ ":" ++ util:date_format(S).
