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
	{ok, _} = application:ensure_all_started(app),
	ok.

stop() ->
	application:stop(app),
	erlang:halt().
