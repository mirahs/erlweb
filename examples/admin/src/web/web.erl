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
	ets:new(?ets_web_path_to_mfd,	[set, public, named_table, {read_concurrency,true}, {keypos, 1}]),	% controller
	ets:new(?ets_web_purview_data,	[set, public, named_table, {read_concurrency,true}, {keypos, 1}]),	% 菜单数据
	ets:new(?ets_web_purview_check,	[set, public, named_table, {read_concurrency,true}, {keypos, 1}]),	% 权限控制

	web_menu:menu_init(),

	PrivDir		= code:priv_dir(admin),
	StaticDir	= PrivDir + "/static/",
	erlweb:init(?web_port, [], StaticDir, ?web_session_app, web_dispatch).
