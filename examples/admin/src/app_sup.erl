%% -*- coding: latin-1 -*-
-module(app_sup).

-behaviour(supervisor).

-export([
    start_link/0

    ,init/1
]).

-include("common.hrl").


%%%===================================================================
%%% API
%%%===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


%%%===================================================================
%%% supervisor callback functions
%%%===================================================================

init([]) ->
    mysql:add_pool(?db_admin, "root", "root", "admin"),

    WebArg = web:init(),

    ErlWeb = {erlweb_sup, {erlweb_sup, start_link, [WebArg]}, permanent, 10000, supervisor, [erlweb_sup]},

    {ok, {{one_for_one, 10, 1}, [ErlWeb]}}.
