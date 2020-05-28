-module(erlweb).

-export([
    init/1
    ,init/2
    ,init/5
    ,init/8
]).


init(Port) ->
    init(Port, [], "", [], undefined, false, "", "").

init(Port, CustomRoutes) ->
    init(Port, CustomRoutes, "", [], undefined, false, "", "").

init(Port, CustomRoutes, StaticDir, SessionApps, Dispatcher) ->
    init(Port, CustomRoutes, StaticDir, SessionApps, Dispatcher, false, "", "").

init(Port, CustomRoutes, StaticDir, SessionApps, Dispatcher, SslOpen, SslCertFile, SslKeyFile) ->
    #{
        port             => Port,
        custom_routes   => CustomRoutes,

        acceptors       => 1000,
        static_dir      => StaticDir,

        session_apps    => SessionApps,
        dispatcher      => Dispatcher,

        ssl_open        => SslOpen,
        ssl_certfile    => SslCertFile,
        ssl_keyfile     => SslKeyFile
    }.
