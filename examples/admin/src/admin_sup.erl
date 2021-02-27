-module(admin_sup).

-behaviour(supervisor).

-export([
    start_link/0

    ,init/1
]).

-define(PORT, 1111).            % web 端口
-define(SESSION_APP, <<"adm">>).% 需要做 session 处理的 app, 多个配置成列表 [<<"adm">>, <<"cp">>]
-define(CHILD(I, Type, Args), {I, {I, start_link, Args}, permanent, 5000, Type, [I]}).


start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


init([]) ->
    MapArg = erlweb:init_session(?PORT, ?SESSION_APP),
    ErlWeb = ?CHILD(erlweb_sup, supervisor, [MapArg]),

    Strategy = {one_for_one, 10, 1},
    {ok, {Strategy, [ErlWeb]}}.
