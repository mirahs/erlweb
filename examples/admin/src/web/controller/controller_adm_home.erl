%% -*- coding: latin-1 -*-
-module(controller_adm_home).

-compile(nowarn_export_all).
-compile(export_all).

-include("common.hrl").
-include("web.hrl").


%% 欢迎
welcome(_Method, _Req, _OPts) ->
    {text, "welcome"}.

%% 清除网站缓存
clear(_Method, Req, _OPts) ->
    Data = cowboy_req:parse_qs(Req),
    case proplists:get_value(<<"act">>, Data) of
        <<"clear">> ->
            web:clear_cache(),
            {error, "成功清除缓存！"};
        _ -> {dtl}
    end.
