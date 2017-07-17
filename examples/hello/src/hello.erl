-module(hello).

-export([
		 start/0,
		 stop/0
		]).


start() ->
	ok = hello_deps:ensure(),
	ok = ensure_started([crypto, cowlib, ranch, cowboy, xxweb, hello]),
	ok.

stop() ->
    application:stop(hello).


ensure_started([App|Apps]) ->
	ok = ensure_started(App),
	ensure_started(Apps);
ensure_started([]) ->
	ok;
ensure_started(App) ->
    case application:start(App) of
        ok ->
            ok;
        {error, {already_started, App}} ->
            ok;
        {error, Error} ->
        	io:format("start App:~p error:~p~n", [App, Error])
    end.
