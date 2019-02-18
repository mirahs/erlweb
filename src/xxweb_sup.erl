-module(xxweb_sup).

-behaviour(supervisor).

-include("common.hrl").

-export([
    start_link/1
]).

-export([
    init/1
]).

-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).


start_link(ArgMap) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [ArgMap]).


init([ArgMap2]) ->
    ArgMap 		= check_module(ArgMap2, [{dispatcher,xxweb_dispatch}]),

    [Port,Acceptors,StaticDir,CustomRoutes,SslOpen,SslCertFile,SslKeyFile] = get_options(ArgMap, [port,acceptors,static_dir,custom_routes,ssl_open,ssl_certfile,ssl_keyfile]),

    Routes		= routes(ArgMap, StaticDir, CustomRoutes),
    Dispatch	= cowboy_router:compile(Routes),
    TransOpts	= [{port, Port}],
    ProtoOpts	= [
        {env,			[{dispatch, Dispatch}]},
        {onrequest,  	fun xxweb_session:on_request/1},
        {onresponse, 	fun xxweb_session:on_response/4}
    ],
    case SslOpen of
        true ->
            TransOptsSsl= [{certfile,SslCertFile},{keyfile,SslKeyFile} | TransOpts],
            {ok, _} = cowboy:start_clear(https, TransOptsSsl, ProtoOpts);
        _ -> {ok, _}	= cowboy:start_clear(http, TransOpts, ProtoOpts)
    end,

    Session	= ?CHILD(xxweb_session_srv, worker),
    {?ok, {{one_for_one, 10, 5}, [Session]} }.



routes(ArgMap, StaticDir, CustomRoutesTmp) ->
    CustomRoutes = ?IF(CustomRoutesTmp =:= ?undefined, [], CustomRoutesTmp),
    [
        {'_', CustomRoutes ++ [
            {"/static/[...]",					cowboy_static,			{dir, StaticDir}},
            {"/[:app/[:module/[:func/[...]]]]",	xxweb_handler,			ArgMap}
        ]
        }
    ].


get_options(ArgMap, Opts) ->
    get_options(ArgMap, Opts, []).

get_options(_ArgMap, [], OptDatas) ->
    lists:reverse(OptDatas);
get_options(ArgMap, [Opt|Opts], OptDatas) ->
    OptData = maps:get(Opt, ArgMap, ?undefined),
    get_options(ArgMap, Opts, [OptData|OptDatas]).

check_module(ArgMap, []) ->
    ArgMap;
check_module(ArgMap, [{Key,Default}|Values]) ->
    case maps:get(Key, ArgMap, ?undefined) of
        ?undefined ->
            check_module(ArgMap#{Key=>Default},Values);
        Module ->
            case xxweb_dispatch:load_module(Module) of
                ?true ->
                    check_module(ArgMap,Values);
                ?false ->
                    check_module(ArgMap#{Key=>Default},Values)
            end
    end.
