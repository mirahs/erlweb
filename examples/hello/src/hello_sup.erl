-module(hello_sup).

-behaviour(supervisor).

-export([
	start_link/0,
	init/1
]).

-define(CHILD(I, Type, Args), {I, {I, start_link, Args}, permanent, 5000, Type, [I]}).


start_link() ->
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
	MapArg = erlweb:init_session(1111, <<"cp">>),
	ErlWeb = ?CHILD(erlweb_sup, supervisor, [MapArg]),

	Strategy = {one_for_one, 10, 1},
	{ok, {Strategy, [ErlWeb]}}.
