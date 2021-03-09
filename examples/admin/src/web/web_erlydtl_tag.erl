-module(web_erlydtl_tag).

-export([
    web_static_url/1

    ,ymdhis/1
    ,ymd/1
]).

-include("web.hrl").


%%%===================================================================
%%% API
%%%===================================================================

%% web 资源地址
web_static_url(_Args) ->
    ?web_static_url.


%% 格式化时间
ymdhis([Unixtime]) when is_integer(Unixtime) andalso Unixtime > 0 ->
    date_YmdHis(Unixtime);
ymdhis(_Args) ->
    "1970-01-01 00:00:00".

%% 格式化日期
ymd([Seconds]) when is_integer(Seconds) andalso Seconds > 0 ->
    util:date_YmdE(Seconds);
ymd(_Args) ->
    "1970-01-01".


%%%===================================================================
%%% Internal functions
%%%===================================================================

date_YmdHis(Seconds) ->
    {{Y,M,D}, {H,I,S}} = util:unixtime2localtime(Seconds),
    util:to_list(Y) ++ "-" ++ util:date_format(M) ++ "-" ++ util:date_format(D) ++ " " ++ util:date_format(H) ++ ":" ++  util:date_format(I) ++ ":" ++ util:date_format(S).
