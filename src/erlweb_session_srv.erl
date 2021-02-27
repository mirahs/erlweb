%% -*- coding: latin-1 -*-
-module(erlweb_session_srv).

-include("common.hrl").

-behaviour(gen_server).

-export([
	start_link/0,

	session_new/0,
	session_get/1,
	session_set/2,
	session_destory/1
]).

-export([
	init/1,
	handle_call/3,
	handle_cast/2,
	handle_info/2,
	terminate/2,
	code_change/3
]).

-record(session, {sid,data,ttl}).


%%% API
start_link() ->
	gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

session_new() ->
	gen_server:call(?MODULE, session_new).

session_get(Sid) ->
	case ets:lookup(?MODULE, Sid) of
		[#session{data=Data}] ->
			Data;
		[] ->
			[]
	end.
%gen_server:call(?MODULE,{session_data_get,Sid}).

session_set(Sid, Sdata) ->
	gen_server:cast(?MODULE, {session_set, Sid, Sdata}).

session_destory(Sid) ->
	gen_server:cast(?MODULE, {session_destory, Sid}).


%%% Callbacks
init([]) ->
	ets:new(?MODULE, [set,public,named_table,{keypos,#session.sid}]),
	{A1, A2, A3} = os:timestamp(),
	random:seed(A1,A2,A3),
	{ok, null}.


handle_call(session_new, _From, State) ->
	Sid	= make_session(),
	{reply, Sid, State};

handle_call({session_get, Sid}, _From, State) ->
	Data = case ets:lookup(?MODULE, Sid) of
			   [#session{data=Sdata}] ->
				   Sdata;
			   [] ->
				   []
		   end,
	{reply, Data, State}.


handle_cast({session_set, Sid, Data}, State) ->
	ets:insert(?MODULE, #session{sid=Sid,data=Data,ttl=0}),
	{noreply, State};

handle_cast({session_destory, Sid}, State) ->
	ets:delete(?MODULE, Sid),
	{noreply, State}.


handle_info(_Info, State) ->
	{noreply, State}.


terminate(_Reason, _State) ->
	ok.


code_change(_OldVsn, State, _Extra) ->
	{ok, State}.


%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
make_session() ->
	Data 	= crypto:strong_rand_bytes(2048),
	ShaList	= binary_to_list(crypto:hash(sha, Data)),
	lists:flatten(list_to_hex(ShaList)).

%% Convert Integer from the SHA to Hex
list_to_hex(L)->
	lists:map(fun(X) -> int_to_hex(X) end, L).

int_to_hex(N) when N < 256 ->
	[hex(N div 16), hex(N rem 16)].

hex(N) when N < 10 ->
	$0 + N;
hex(N) when N >= 10, N < 16 ->
	$a + (N - 10).
