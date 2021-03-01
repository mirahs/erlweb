%% -*- coding: latin-1 -*-
-module(erlweb).

-export([
    init/1
    ,init/2
    ,init_session/2
    ,init/5
    ,init/8

    ,stop/0
]).

-include("erlweb.hrl").


%%%===================================================================
%%% API
%%%===================================================================

init(Port) ->
    init(Port, []).

init(Port, CustomRoutes) ->
    init(Port, CustomRoutes, "", [], undefined).

init_session(Port, SessionApps = [_|_]) ->
    init(Port, [], "", SessionApps, undefined);
init_session(Port, SessionApps) ->
    init(Port, [], "", [SessionApps], undefined).

init(Port, CustomRoutes, StaticDir, SessionApps, Dispatcher) ->
    init(Port, CustomRoutes, StaticDir, SessionApps, Dispatcher, false, "", "").

init(Port, CustomRoutes, StaticDir, SessionApps, Dispatcher, SslOpen, SslCertFile, SslKeyFile) ->
    #{
        port             => Port,
        custom_routes   => CustomRoutes,

        static_dir      => StaticDir,

        session_apps    => SessionApps,
        dispatcher      => Dispatcher,

        ssl_open        => SslOpen,
        ssl_certfile    => SslCertFile,
        ssl_keyfile     => SslKeyFile
    }.


stop() ->
    Res = cowboy:stop_listener(erlweb),
    ?INFO("Res:~p", [Res]),
    ok.
