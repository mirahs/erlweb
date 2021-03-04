%% -*- coding: latin-1 -*-
-module(controller_adm_index).

-compile(nowarn_export_all).
-compile(export_all).

-include("common.hrl").
-include("web.hrl").


%% 主页
index(_Method, _Req, _OPts) ->
    case web_adm:check_login() of
        true ->
            %Type = web_cp:get_type(),
            Type = ?adm_user_type_admin,
            {_Menus, _PurviewKeys} = web_adm_menu:menus(Type),
            {ok, dtl, [
%%                {project_name,	?PROJECT_NAME},
%%                {static_url, 	?STATIC_URL},
%%                {admin_name,	maps:get(Type, ?CP_PURVIEW_LIST)},
%%                {account,		web_cp:get_account()},
%%                {purview_keys,	PurviewKeys},
%%                {menus,			Menus}
            ]};
        false -> {redirect, "/adm/login"}
    end.


%% 登陆
login(?web_get, Req, _Opts) ->
    case web_adm:check_login() of
        true -> {redirect, "/adm/index", Req};
        false ->
            {ok, dtl, [{web_project_name, ?web_project_name}]}
    end;
login(?web_post, Req, _Opts) ->
    case web_adm:login(Req) of
        {ok} -> {json, web:echo_success()};
        {error, ErrorMsg} -> {json, web:echo_failed(ErrorMsg)}
    end.
