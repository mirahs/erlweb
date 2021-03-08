%% -*- coding: latin-1 -*-
-module(controller_adm_sys).

-compile(nowarn_export_all).
-compile(export_all).

-include("common.hrl").
-include("web.hrl").


%% 密码更新
password(?web_get, Req, _Opts) ->
    Data    = cowboy_req:parse_qs(Req),
    Account0= proplists:get_value(<<"account">>, Data),
    Account = ?IF(Account0 =:= undefined, web_adm:get_account(), Account0),
    {dtl, [{account, Account}]};
password(?web_post, Req, _Opts) ->
    {ok, Data, _Req2} = cowboy_req:read_urlencoded_body(Req),
    Account = proplists:get_value(<<"account">>, Data, <<>>),
    Password= proplists:get_value(<<"password">>, Data, <<>>),
    ?IF(Account =:= <<>> orelse Password =:= <<>>, ?web_failed("请输入正确的数据"), skip),
    tbl_adm_user:update_password_by_account(Account, util:md5(util:md5(Password))),
    web:echo_success().
