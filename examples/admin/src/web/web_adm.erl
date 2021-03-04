%% -*- coding: latin-1 -*-
-module(web_adm).

-export([
    check_login/0
    ,login/1

    ,get_id/0
    ,get_account/0
    ,get_type/0
    ,get_type_name/0
    ,get_type_name/1
]).

-include("common.hrl").
-include("web.hrl").

-define(session_id,         session_id).
-define(session_account,    session_account).
-define(session_password,   session_password).
-define(session_type,       session_type).
-define(session_hash,       session_hash).


%%%===================================================================
%%% API
%%%===================================================================

%% 检查是否登录
check_login() ->
    UserName	= erlweb_session:get(?session_account),
    Password	= erlweb_session:get(?session_password),
    Hash		= erlweb_session:get(?session_hash),

    HashRule	= login_key_rule(UserName, Password),
    Hash =:= HashRule.

%% 登录
login(Req) ->
    {ok, PostVals, _Req2} = cowboy_req:read_urlencoded_body(Req),
    _IP     = util:cowboy_ip(Req),
    Account = proplists:get_value(<<"account">>, PostVals),
    Password= proplists:get_value(<<"password">>, PostVals),
    case Account =:= <<"admin">> andalso Password =:= util:to_binary(util:md5("admin")) of
        true ->
            Hash = login_key_rule(Account, Password),
            erlweb_session:set([
                {?session_id,			99999999}
                ,{?session_account,		Account}
                ,{?session_password,	Password}
                ,{?session_type,		?adm_user_type_admin}
                ,{?session_hash,		Hash}
            ]),
            {ok};
        false ->  {error, "账号或密码错误"}
    end.


%% 账号ID
get_id() ->
    erlweb_session:get(?session_id, 0).

%% 帐号
get_account() ->
    erlweb_session:get(?session_account, "").

%% 帐号类型
get_type() ->
    erlweb_session:get(?session_type, 0).

%% 账号类型名称
get_type_name() ->
    get_type_name(get_type()).
get_type_name(Type) ->
    maps:get(?adm_user_types_desc, Type, "").


%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 登录 hash
login_key_rule(Account, Password) ->
    crypto:hash(sha, util:to_list(Account) ++ util:to_list(Password)).
