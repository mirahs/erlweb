%% -*- coding: latin-1 -*-
-module(erlweb_session).

-export([
    execute/2
    ,on_response/1
]).

-export([
    get/1,
    get/2,
    set/1,
    set/2,
    del/1,
    destory/1
]).

-include("erlweb.hrl").

-define(dict_session_id,        dict_session_id).
-define(dict_session_keys,		dict_session_keys).
-define(SESSION_COOKIE,			<<"session_cookie">>).
-define(SESSION_COOKIE_ATOM,	session_cookie).


execute(Req, Env = #{handler_opts := #{session_apps := SessionApps}}) ->
    AppBTmp = cowboy_req:binding(app, Req),
    AppB    = ?IF(AppBTmp =:= undefined, <<"index">>, AppBTmp),
    case lists:member(AppB, SessionApps) of
        true ->
            erlang:erase(?dict_session_id),
            case cowboy_req:match_cookies([{?SESSION_COOKIE_ATOM, [], <<>>}], Req) of
                #{session_cookie := SessionId} when SessionId =/= <<"">> ->
                    SessionData	= erlweb_session_srv:session_get(SessionId),
                    %?INFO("SessionId:~p", [SessionId]),
                    %?INFO("SessionData:~p", [SessionData]),
                    [erlang:put(Key, Value) || {Key, Value} <- SessionData],
                    erlang:put(?dict_session_id, SessionId),
                    erlang:put(?dict_session_keys, [Key || {Key, _Data} <- SessionData]),
                    {ok, Req, Env};
                _ ->
                    SessionId = session_id(Req),
                    %?INFO("SessionId:~p", [SessionId]),
                    erlang:put(?dict_session_id, SessionId),
                    erlang:put(?dict_session_keys, []),
                    Req2 = cowboy_req:set_resp_cookie(?SESSION_COOKIE, SessionId, Req, #{path => <<"/">>}),
                    {ok, Req2, Env}
            end;
        false -> {ok, Req, Env}
    end.

%% 返回前调用
on_response(Req) ->
    case erlang:get(?dict_session_id) of
        undefined -> skip;
        SessionId -> session_set(SessionId)
    end,
    Req.


%% API
get(Key) ->
    ?MODULE:get(Key, undefined).

get(Key, DefaultValue) ->
    case erlang:get(Key) of
        undefined ->
            DefaultValue;
        Value ->
            Value
    end.

set(Key, Value) ->
    erlang:put(Key, Value),
    Keys = erlang:get(?dict_session_keys),
    erlang:put(?dict_session_keys, [Key|lists:delete(Key, Keys)]).

set(KeyValues) ->
    [set(Key, Value) || {Key, Value} <- KeyValues].

del() ->
    Keys= erlang:get(?dict_session_keys),
    [del(Key) || Key <- Keys].

del(Key) ->
    erlang:erase(Key),
    Keys= erlang:get(?dict_session_keys),
    erlang:put(?dict_session_keys, lists:delete(Key, Keys)).

destory(Req) ->
    SessionId = session_id(Req, false),
    del(),
    erlweb_session_srv:session_destory(SessionId),
    cowboy_req:set_resp_cookie(?SESSION_COOKIE, <<"">>, Req, #{path => <<"/">>}).



session_id(Req) ->
    session_id(Req, true).

session_id(Req, true) ->
    case cowboy_req:match_cookies([{?SESSION_COOKIE_ATOM, [], <<>>}], Req) of
        #{session_cookie:=SessionId} when SessionId =/= <<"">> ->
            ?TOB(SessionId);
        _ ->
            ?TOB(erlweb_session_srv:session_new())
    end;
session_id(Req, false) ->
    case cowboy_req:match_cookies([{?SESSION_COOKIE_ATOM, [], <<>>}], Req) of
        #{session_cookie:=SessionId} when SessionId =/= <<"">> ->
            ?TOB(SessionId);
        _ ->
            <<"0">>
    end.


session_set(SessionId) ->
    SessionKeys	= erlang:get(?dict_session_keys),
    SessionData	= [{Key, erlang:get(Key)} || Key <- SessionKeys],%?INFO("SessionData:~p", [SessionData]),
    erlweb_session_srv:session_set(SessionId, SessionData).
