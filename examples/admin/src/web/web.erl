%% -*- coding: latin-1 -*-
-module(web).

-export([
	init/0
]).

-include("common.hrl").
-include("web.hrl").


%%%===================================================================
%%% API
%%%===================================================================

init() ->
	ets:new(?ets_web_path2mfd,	[set, public, named_table, {read_concurrency,true}, {keypos, 1}]),
	ets:new(?ets_web_menu_data,	[set, public, named_table, {read_concurrency,true}, {keypos, 1}]),
	ets:new(?ets_web_menu_check,[set, public, named_table, {read_concurrency,true}, {keypos, 1}]),

	web_adm_menu:menu_init(),

	PrivDir		= code:priv_dir(admin),
	StaticDir	= PrivDir ++ "/static/",
	erlweb:init(?web_port, [], StaticDir, ?web_session_app, web_erlweb_dispatch).
