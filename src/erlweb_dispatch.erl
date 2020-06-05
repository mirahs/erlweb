-module(erlweb_dispatch).

-export([
    get/4,
    load_module/1
]).

-include("common.hrl").


get(Path = <<"/favicon.ico">>, _AppB, _ModuleB, _FuncB) -> {error, Path};
get(Path, AppB, undefined, _FuncB) -> get(Path, AppB, <<"index">>, <<"index">>);
get(Path, AppB, ModuleB, undefined) -> get(Path, AppB, ModuleB, <<"index">>);
get(Path, AppB, ModuleB, FuncB) -> {ok, set(Path, AppB, ModuleB, FuncB)}.

load_module(Module) ->
    case erlang:module_loaded(Module) of
        true -> true;
        false ->
            code:purge(Module),
            case code:load_file(Module) of
                {module, Module} -> true;
                {?error, Reason} ->
                    ?ERR("(~p) load fail : ~p~n", [Module, Reason]),
                    false
            end
    end.


set(Path, AppB, ModuleB, FuncB) ->
    ControllerB	= <<"controller_", AppB/binary, "_", ModuleB/binary>>,
    {ControllerA, FuncA, ModuleA} = {?TOA(ControllerB), ?TOA(FuncB), ?TOA(ModuleB)},
    {ControllerFinalA, ModuleFinalA, FuncFinalA, ModuleFinalB, FuncFinalB} =
        case load_module(ControllerA) of
            ?true ->
                case erlang:function_exported(ControllerA, FuncA, 3) of
                    ?true ->
                        {ControllerA, ModuleA, FuncA, ModuleB, FuncB};
                    ?false ->
                        {ControllerA, ModuleA, index, ModuleB, <<"index">>}
                end;
            ?false ->
                FuncA2	= ?TOA(ModuleB),
                FuncB2	= ModuleB,
                ControllerB1	= <<"controller_", AppB/binary, "_", (<<"index">>)/binary >>,
                ControllerA1	= ?TOA(ControllerB1),
                load_module(ControllerA1),
                {ControllerA1, index, FuncA2, <<"index">>, FuncB2}
        end,
    %模板注册
    DtlB 	= <<"view_", AppB/binary, "_", ModuleFinalB/binary, "_", FuncFinalB/binary >>,
    DtlA 	= ?TOA(DtlB),
    DtlEditB= <<"view_", AppB/binary, "_", ModuleFinalB/binary, "_", FuncFinalB/binary, "_edit" >>,
    DtlEditA= ?TOA(DtlEditB),
    PathH	= #{path=>Path,controller=>ControllerFinalA,module=>ModuleFinalA,func=>FuncFinalA,
        dtl=>DtlA,dtle=>DtlEditA},
    PathH.
