-module(xxweb_session).

-include("common.hrl").

-export([
		 get/1,
		 get/2,
		 set/1,
		 set/2,
		 del/1,
		 destory/1,
		 
		 on_request/1,
		 on_response/4
		 ]).

-define(SESSION_KEYS,			session_keys).
-define(SESSION_COOKIE,			<<"session_cookie">>).
-define(SESSION_COOKIE_ATOM,	session_cookie).


%% API
get(Key) ->
	?MODULE:get(Key, ?undefined).

get(Key, DefaultValue) ->
	case erlang:get(Key) of
		?undefined ->
			DefaultValue;
		Value ->
			Value
	end.

set(Key, Value) ->
	erlang:put(Key, Value),
	Keys = erlang:get(?SESSION_KEYS),
	erlang:put(?SESSION_KEYS, [Key|lists:delete(Key, Keys)]).

set(KeyValues) ->
	[set(Key, Value) || {Key, Value} <- KeyValues].

del() ->
	Keys= erlang:get(?SESSION_KEYS),
	[del(Key) || Key <- Keys].

del(Key) ->
	erlang:erase(Key),
	Keys= erlang:get(?SESSION_KEYS),
	erlang:put(?SESSION_KEYS, lists:delete(Key, Keys)).

destory(Req) ->
	SessionId = session_id(Req, ?false),
	del(),
	xxweb_session_srv:session_destory(SessionId),
	cowboy_req:set_resp_cookie(?SESSION_COOKIE, <<"">>, [{path, <<"/">>}], Req).

%% 请求时调用
on_request(Req) ->
	case cowboy_req:match_cookies([?SESSION_COOKIE_ATOM], Req) of
		#{session_cookie:=SessionId} when SessionId =/= <<"">> ->
			SessionData	= xxweb_session_srv:session_get(SessionId),
			%?INFO("SessionId : ~p~n", [SessionId]),
			%?INFO("SessionData : ~p~n", [SessionData]),
			[erlang:put(Key, Value) || {Key, Value} <- SessionData],
			erlang:put(?SESSION_KEYS, [Key || {Key, _Data} <- SessionData]),
			Req;
		_ ->
			SessionId = session_id(Req),
			%?INFO("SessionId : ~p~n", [SessionId]),
			erlang:put(?SESSION_KEYS, []),
			cowboy_req:set_resp_cookie(?SESSION_COOKIE, SessionId, [{path, <<"/">>}], Req)
	end.

%% 返回前调用
on_response(_Status, _Headers, _Body, Req) ->
	case erlang:get(?SESSION_KEYS) of
		?undefined ->
			?skip;
		_ ->
			case cowboy_req:match_cookies([?SESSION_COOKIE_ATOM], Req) of
				#{session_cookie:=SessionId} when SessionId =/= <<"">> ->
					session_set(SessionId);
				_ ->
					?skip
			end
	end,
	Req.



session_id(Req) ->
	session_id(Req, ?true).

session_id(Req, ?true) ->
	case cowboy_req:match_cookies([?SESSION_COOKIE_ATOM], Req) of
		#{session_cookie:=SessionId} when SessionId =/= <<"">> ->
			?TOB(SessionId);
		_ ->
			?TOB(xxweb_session_srv:session_new())
	end;
session_id(Req, ?false) ->
	case cowboy_req:match_cookies([?SESSION_COOKIE_ATOM], Req) of
		#{session_cookie:=SessionId} when SessionId =/= <<"">> ->
			?TOB(SessionId);
		_ ->
			<<"0">>
	end.


session_set(SessionId) ->
	SessionKeys	= erlang:get(?SESSION_KEYS),
	SessionData	= [{Key, erlang:get(Key)} || Key <- SessionKeys],
	xxweb_session_srv:session_set(SessionId, SessionData).
