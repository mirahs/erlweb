-module(admin_sup).

-behaviour(supervisor).

-export([
    start_link/0

    ,init/1
]).

-include("common.hrl").


start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
    WebArg = erlweb:init_session(?web_port, ?web_session_app),

    ErlWeb = {erlweb_sup, {erlweb_sup, start_link, [WebArg]}, permanent, 10000, supervisor, [erlweb_sup]},

    Strategy = {one_for_one, 10, 1},
    {ok, {Strategy, [ErlWeb]}}.
