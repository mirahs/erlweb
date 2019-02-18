-module(hello).

-export([
	start/0
	,stop/0
]).


start() ->
	application:ensure_all_started(hello).

stop() ->
    application:stop(hello).
