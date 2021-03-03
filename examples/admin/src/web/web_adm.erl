%% -*- coding: latin-1 -*-
-module(web_adm).

-export([
    check_login/0
]).

-include("common.hrl").
-include("web.hrl").


%%%===================================================================
%%% API
%%%===================================================================

%% 检查是否登录
check_login() ->
    UserName	= erlweb_session:get(session_username),
    Password	= erlweb_session:get(session_password),
    Hash		= erlweb_session:get(session_hash),

    HashRule	= login_key_rule(UserName, Password),
    Hash =:= HashRule.


%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 登录 hash
login_key_rule(UserName, Password) ->
    crypto:hash(sha, util:to_list(UserName) ++ util:to_list(Password)).
