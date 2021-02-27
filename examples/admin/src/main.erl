%% -*- coding: latin-1 -*-
-module(main).

-export([
	start/0
	,stop/0
]).


%%%===================================================================
%%% API
%%%===================================================================

start() ->
	{ok, _} = application:ensure_all_started(admin),
	ok.

stop() ->
	application:stop(admin),
	erlang:halt().
