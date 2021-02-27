-module(admin).

-export([
	start/0
	,stop/0
]).


start() ->
	{ok, _} = application:ensure_all_started(admin),
	ok.

stop() ->
	application:stop(admin).
