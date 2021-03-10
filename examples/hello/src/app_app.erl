%% -*- coding: latin-1 -*-
-module(app_app).

-behaviour(application).

-export([
	start/2
	,stop/1
]).


start(_StartType, _StartArgs) ->
	app_sup:start_link().

stop(_State) ->
    erlweb:stop(),
	ok.
