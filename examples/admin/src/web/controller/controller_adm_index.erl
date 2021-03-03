%% -*- coding: latin-1 -*-
-module(controller_adm_index).

-compile(nowarn_export_all).
-compile(export_all).

-include("web.hrl").


%% 主页
index(_Method, _Req, _OPts) ->
    case web_adm:check_login() of
        true ->
            Type = web_cp:get_type(),
            {Menus, PurviewKeys} = web_adm_menu:purview(Type),
            {ok, dtl, [
%%                {project_name,	?PROJECT_NAME},
%%                {static_url, 	?STATIC_URL},
%%                {admin_name,	maps:get(Type, ?CP_PURVIEW_LIST)},
%%                {account,		web_cp:get_account()},
%%                {purview_keys,	PurviewKeys},
%%                {menus,			Menus}
            ]};
        false ->
            {redirect, "/adm/login"}
    end.


%% 登陆
login(?web_get, Req, _Opts) ->
    case web_adm:check_login() of
        true -> {redirect, "/adm/index", Req};
        false ->
            {ok, dtl, [
%%                {project_name, ?PROJECT_NAME},
%%                {powered_corp_url, ?POWERED_CORP_URL},
%%                {powered_corp_name, ?POWERED_CORP_NAME},
%%                {powered_studio_url, ?POWERED_STUDIO_URL},
%%                {powered_studio_name, ?POWERED_STUDIO_NAME},
%%                {ip_count, ?CP_IP_COUNT}
            ]}
    end;
login(?web_post, Req, _Opts) ->
    case web_adm:login(Req) of
        {ok, Req2} ->
            {redirect, "/adm/index", Req2};
        {error, ErrorMsg} ->
            {error, ErrorMsg}
    end.
