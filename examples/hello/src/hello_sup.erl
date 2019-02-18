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
	ArgMap	= #{
		port		=> 8080,
		acceptors	=> 800,
		static_dir	=> "/data/xxweb/assets",
		apps		=> [<<"api">>,<<"cp">>,<<"doc">>],
		session_apps=> [<<"cp">>]
	},
	XXWeb	= ?CHILD(xxweb_sup, supervisor, [ArgMap]),

	Strategy= {one_for_one, 10, 1},
	{ok, {Strategy, [XXWeb]}}.
