-module(erlweb_sup).

-behaviour(supervisor).

-export([
    start_link/1
]).

-export([
    init/1
]).

-include("common.hrl").

-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).


%%%===================================================================
%%% API
%%%===================================================================

start_link(ArgMap) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, [ArgMap]).


init([ArgMap2]) ->
    ArgMap 		= check_module(ArgMap2, [{dispatcher, erlweb_dispatch}]),

    [Port, StaticDir, CustomRoutes, SslOpen, SslCertFile, SslKeyFile] = get_options(ArgMap, [port, static_dir, custom_routes, ssl_open, ssl_certfile, ssl_keyfile]),

    Routes		= routes(ArgMap, StaticDir, CustomRoutes),
    Dispatch	= cowboy_router:compile(Routes),
    TransOpts	= [{port, Port}],
    ProtoOpts	= #{
        env => #{dispatch => Dispatch}
        ,middlewares => [cowboy_router, erlweb_session, cowboy_handler]
    },
    case SslOpen of
        true ->
            TransOptsSsl = [{certfile, SslCertFile}, {keyfile, SslKeyFile} | TransOpts],
            {ok, _} = cowboy:start_tls(erlweb, TransOptsSsl, ProtoOpts);
        _ -> {ok, _}	= cowboy:start_clear(erlweb, TransOpts, ProtoOpts)
    end,

    Session	= ?CHILD(erlweb_session_srv, worker),
    {ok, {{one_for_one, 10, 5}, [Session]} }.


%%%===================================================================
%%% Internal functions
%%%===================================================================

routes(ArgMap, StaticDir, CustomRoutesTmp) ->
    CustomRoutes = ?IF(CustomRoutesTmp =:= undefined, [], CustomRoutesTmp),
    [
        {'_', CustomRoutes ++ [
            {"/static/[...]",					cowboy_static,			{dir, StaticDir}},
            {"/[:app/[:module/[:func/[...]]]]",	erlweb_handler,		ArgMap}
        ]}
    ].


get_options(ArgMap, Opts) -> get_options(ArgMap, Opts, []).

get_options(_ArgMap, [], OptDatas) -> lists:reverse(OptDatas);
get_options(ArgMap, [Opt | Opts], OptDatas) ->
    OptData = maps:get(Opt, ArgMap, undefined),
    get_options(ArgMap, Opts, [OptData|OptDatas]).

check_module(ArgMap, []) -> ArgMap;
check_module(ArgMap, [{Key, Default} | Values]) ->
    case maps:get(Key, ArgMap, undefined) of
        undefined -> check_module(ArgMap#{Key => Default}, Values);
        Module ->
            case erlweb_util:load_module(Module) of
                true -> check_module(ArgMap, Values);
                false -> check_module(ArgMap#{Key => Default}, Values)
            end
    end.
