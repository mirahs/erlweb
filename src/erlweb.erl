-module(erlweb).

-export([
    init/1
    ,init/2
    ,init/6
    ,init/9
]).


init(Port) ->
    init(Port, [], "", [], [], undefined, false, "", "").

init(Port, CustomRoutes) ->
    init(Port, CustomRoutes, "", [], [], undefined, false, "", "").

init(Port, CustomRoutes, StaticDir, Apps, SessionApps, Dispatcher) ->
    init(Port, CustomRoutes, StaticDir, Apps, SessionApps, Dispatcher, false, "", "").

init(Port, CustomRoutes, StaticDir, Apps, SessionApps, Dispatcher, SslOpen, SslCertFile, SslKeyFile) ->
    #{
        port             => Port,
        custom_routes   => CustomRoutes,

        acceptors       => 1000,
        static_dir      => StaticDir,

        apps             => Apps,
        session_apps    => SessionApps,
        dispatcher      => Dispatcher,

        ssl_open        => SslOpen,
        ssl_certfile    => SslCertFile,
        ssl_keyfile     => SslKeyFile
    }.
