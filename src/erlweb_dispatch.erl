%% -*- coding: latin-1 -*-
-module(erlweb_dispatch).

-export([
    get/4
]).

-include("common.hrl").


get(Path = <<"/favicon.ico">>, _AppB, _ModuleB, _FuncB) -> {error, Path};
get(Path, undefined, _ModuleB, _FuncB) -> get(Path, <<"index">>, <<"index">>, <<"index">>);
get(Path, AppB, undefined, _FuncB) -> get(Path, AppB, <<"index">>, <<"index">>);
get(Path, AppB, ModuleB, undefined) -> get(Path, AppB, ModuleB, <<"index">>);
get(Path, AppB, ModuleB, FuncB) -> {ok, set(Path, AppB, ModuleB, FuncB)}.


set(Path, AppB, ModuleB, FuncB) ->
    ControllerB	= <<"controller_", AppB/binary, "_", ModuleB/binary>>,
    {ControllerA, FuncA, ModuleA} = {?TOA(ControllerB), ?TOA(FuncB), ?TOA(ModuleB)},
    {ControllerFinalA, ModuleFinalA, ModuleFinalB, FuncFinalA, FuncFinalB} =
        case erlweb_util:load_module(ControllerA) of
            true ->
                case erlang:function_exported(ControllerA, FuncA, 3) of
                    true ->
                        {ControllerA, ModuleA, ModuleB, FuncA, FuncB};
                    false ->
                        {ControllerA, ModuleA, ModuleB, index, <<"index">>}
                end;
            false ->
                ModuleB2= <<"index">>,
                FuncA2	= ?TOA(ModuleB),
                FuncB2	= ModuleB,
                ControllerB1 = <<"controller_", AppB/binary, "_", ModuleB2/binary >>,
                ControllerA1 = ?TOA(ControllerB1),
                erlweb_util:load_module(ControllerA1),
                {ControllerA1, index, ModuleB2, FuncA2, FuncB2}
        end,
    % 模板注册(显示和编辑)
    DtlB 	= <<"view_", AppB/binary, "_", ModuleFinalB/binary, "_", FuncFinalB/binary >>,
    DtlA 	= ?TOA(DtlB),
    DtlEditB= <<"view_", AppB/binary, "_", ModuleFinalB/binary, "_", FuncFinalB/binary, "_edit" >>,
    DtlEditA= ?TOA(DtlEditB),
    #{path => Path, controller => ControllerFinalA, module => ModuleFinalA, func => FuncFinalA, dtl => DtlA, dtle => DtlEditA}.
