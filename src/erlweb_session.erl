%% -*- coding: latin-1 -*-
-module(erlweb_session).

-export([
    execute/2
    ,on_response/1
]).

-export([
    get/1
    ,get/2
    ,set/2
    ,set/1
    ,del/1
    ,destory/1
]).

-include("erlweb.hrl").

-define(dict_session_id,        dict_session_id).
-define(dict_session_keys,		dict_session_keys).
-define(cookie_session_id,		<<"cserlwebid">>).
-define(cookie_session_id_atom,	cserlwebid).


%%%===================================================================
%%% middleware
%%%===================================================================

execute(Req, Env = #{handler_opts := #{session_apps := SessionApps}}) ->
    AppBTmp = cowboy_req:binding(app, Req),
    AppB    = ?IF(AppBTmp =:= undefined, <<"index">>, AppBTmp),
    case lists:member(AppB, SessionApps) of
        true ->
            erlang:erase(?dict_session_id),
            case cowboy_req:match_cookies([{?cookie_session_id_atom, [], <<>>}], Req) of
                #{?cookie_session_id_atom := SessionId} when SessionId =/= <<>> ->
                    SessionData	= erlweb_session_mgr:get(SessionId),
                    %?INFO("SessionId:~p", [SessionId]),
                    %?INFO("SessionData:~p", [SessionData]),
                    SessionKeys = [begin erlang:put(Key, Value), Key end || {Key, Value} <- SessionData],
                    erlang:put(?dict_session_id, SessionId),
                    erlang:put(?dict_session_keys, SessionKeys),
                    {ok, Req, Env};
                _ ->
                    SessionId = session_id(Req),
                    %?INFO("SessionId:~p", [SessionId]),
                    erlang:put(?dict_session_id, SessionId),
                    erlang:put(?dict_session_keys, []),
                    Req2 = cowboy_req:set_resp_cookie(?cookie_session_id, SessionId, Req, #{path => <<"/">>}),
                    {ok, Req2, Env}
            end;
        false -> {ok, Req, Env}
    end;
execute(Req, Env) ->
    {ok, Req, Env}.

%% 返回前调用
on_response(Req) ->
    case erlang:get(?dict_session_id) of
        undefined -> skip;
        SessionId -> session_set(SessionId)
    end,
    Req.


%%%===================================================================
%%% API
%%%===================================================================

get(Key) ->
    ?MODULE:get(Key, undefined).

get(Key, DefaultValue) ->
    case erlang:get(Key) of
        undefined -> DefaultValue;
        Value -> Value
    end.

set(Key, Value) ->
    erlang:put(Key, Value),
    Keys = erlang:get(?dict_session_keys),
    erlang:put(?dict_session_keys, [Key | lists:delete(Key, Keys)]).

set(KeyValues) ->
    [set(Key, Value) || {Key, Value} <- KeyValues].

del(Key) ->
    erlang:erase(Key),
    Keys = erlang:get(?dict_session_keys),
    erlang:put(?dict_session_keys, lists:delete(Key, Keys)).

destory(Req) ->
    SessionId = erlang:get(?dict_session_id),
    erlang:erase(?dict_session_id),

    destory(),

    erlweb_session_mgr:destory(SessionId),
    cowboy_req:set_resp_cookie(?cookie_session_id, <<>>, Req, #{path => <<"/">>}).
destory() ->
    Keys = erlang:get(?dict_session_keys),
    [del(Key) || Key <- Keys],
    erlang:erase(?dict_session_keys).


%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 获取链接 session id
session_id(Req) ->
    case cowboy_req:match_cookies([{?cookie_session_id_atom, [], <<>>}], Req) of
        #{?cookie_session_id_atom := SessionId} when SessionId =/= <<>> -> SessionId;
        _ -> erlweb_util:to_binary(erlweb_session_mgr:new())
    end.

session_set(SessionId) ->
    SessionKeys	= erlang:get(?dict_session_keys),
    SessionData	= [{Key, erlang:get(Key)} || Key <- SessionKeys],%?INFO("SessionData:~p", [SessionData]),
    erlweb_session_mgr:set(SessionId, SessionData).
