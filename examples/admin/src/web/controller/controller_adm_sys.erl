%% -*- coding: latin-1 -*-
-module(controller_adm_sys).

-compile(nowarn_export_all).
-compile(export_all).

-include("common.hrl").
-include("web.hrl").


%% 登陆
login(?web_get, Req, _Opts) ->
    case web_adm:check_login() of
        true -> {redirect, "/adm/index", Req};
        false -> {dtl, [{web_project_name, ?web_project_name}]}
    end;
login(?web_post, Req, _Opts) ->
    case web_adm:login(Req) of
        {ok} -> {json, web:echo_success()};
        {error, ErrorMsg} -> {json, web:echo_failed(ErrorMsg)}
    end.
