%% -*- coding: latin-1 -*-
-module(erlweb_session_mgr).

-behaviour(gen_server).

-export([
    start_link/0

    ,new/0
    ,get/1
    ,set/2
    ,destory/1
]).

-export([
    init/1
    ,handle_call/3
    ,handle_cast/2
    ,handle_info/2
    ,terminate/2
    ,code_change/3
]).

-include("erlweb.hrl").

-record(session, {sid, data, ttl}).


%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

new() ->
    make_session().

get(Sid) ->
    case ets:lookup(?MODULE, Sid) of
        [#session{data = Data}] -> Data;
        [] -> []
    end.

set(Sid, Data) ->
    gen_server:cast(?MODULE, {set, Sid, Data}).

destory(Sid) ->
    gen_server:cast(?MODULE, {destory, Sid}).


%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

init([]) ->
    ets:new(?MODULE, [named_table, set, protected, {keypos, #session.sid}, {read_concurrency, true}]),
    {ok, null}.

handle_call(new, _From, State) ->
    {reply, make_session(), State};
handle_call({get, Sid}, _From, State) ->
    Data =
        case ets:lookup(?MODULE, Sid) of
            [#session{data = Data}] -> Data;
            [] -> []
        end,
    {reply, Data, State}.

handle_cast({set, Sid, Data}, State) ->
    ets:insert(?MODULE, #session{sid = Sid, data = Data, ttl = 0}),
    {noreply, State};
handle_cast({destory, Sid}, State) ->
    ets:delete(?MODULE, Sid),
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


%%%===================================================================
%%% Internal functions
%%%===================================================================

make_session() ->
    Data 	= crypto:strong_rand_bytes(2048),
    Hash    = binary_to_list(crypto:hash(sha, Data)),
    lists:flatten(list_to_hex(Hash)).

%% Convert Integer from the SHA to Hex
list_to_hex(L)->
    lists:map(fun(X) -> int_to_hex(X) end, L).

int_to_hex(N) when N < 256 ->
    [hex(N div 16), hex(N rem 16)].

hex(N) when N < 10 ->
    $0 + N;
hex(N) when N >= 10, N < 16 ->
    $a + (N - 10).
