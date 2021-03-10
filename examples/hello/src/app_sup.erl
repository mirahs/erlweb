-module(app_sup).

-behaviour(supervisor).

-export([
    start_link/0

    ,init/1
]).

-define(PORT, 1111).            % web 端口
-define(SESSION_APP, <<"adm">>).% 需要做 session 处理的 app, 多个配置成列表 [<<"adm">>, <<"cp">>]


start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
    WebArg  = erlweb:init_session(?PORT, ?SESSION_APP),
    ErlWeb  = {erlweb_sup, {erlweb_sup, start_link, [WebArg]}, permanent, infinity, supervisor, [erlweb_sup]},

    {ok, {{one_for_one, 10, 10}, [ErlWeb]}}.
