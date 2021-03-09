%% -*- coding: latin-1 -*-
-module(util).

-export([
    md5/1

    ,to_atom/1
    ,to_list/1
    ,to_binary/1
    ,to_float/1
    ,to_integer/1
    ,to_tuple/1
    ,list_to_atom/1

    ,unixtime/0
    ,now/0
    ,unixtime2localtime/1
    ,date_format/1
]).

-include("common.hrl").

%% 0000 到 1970 年的秒数
-define(diff_seconds_0000_1970, 62167219200).


%%%===================================================================
%%% API
%%%===================================================================

md5(S) ->
    binary_to_list(list_to_binary([io_lib:format("~2.16.0b", [N]) || N <- binary_to_list(erlang:md5(S))])).


%%%===================================================================
%%% 类型转换
%%%===================================================================

%% atom
to_atom(Msg) when is_atom(Msg) ->
    Msg;
to_atom(Msg) when is_binary(Msg) ->
    ?MODULE:list_to_atom(binary_to_list(Msg));
to_atom(Msg) when is_integer(Msg) ->
    ?MODULE:list_to_atom(integer_to_list(Msg));
to_atom(Msg) when is_tuple(Msg) ->
    ?MODULE:list_to_atom(tuple_to_list(Msg));
to_atom(Msg) when is_list(Msg) ->
    Msg2 = list_to_binary(Msg),
    Msg3 = binary_to_list(Msg2),
    ?MODULE:list_to_atom(Msg3);
to_atom(_) ->
    ?MODULE:list_to_atom("").

%% list
to_list(Msg) when is_list(Msg) ->
    Msg;
to_list(Msg) when is_atom(Msg) ->
    atom_to_list(Msg);
to_list(Msg) when is_binary(Msg) ->
    binary_to_list(Msg);
to_list(Msg) when is_integer(Msg) ->
    integer_to_list(Msg);
to_list(Msg) when is_float(Msg) ->
    float_to_list(Msg);
to_list(_) ->
    [].

%% binary
to_binary(Msg) when is_binary(Msg) ->
    Msg;
to_binary(Msg) when is_atom(Msg) ->
    list_to_binary(atom_to_list(Msg));
to_binary(Msg) when is_list(Msg) ->
    list_to_binary(Msg);
to_binary(Msg) when is_integer(Msg) ->
    list_to_binary(integer_to_list(Msg));
to_binary(_Msg) ->
    <<>>.

%% float
to_float(Msg)->
    Msg2 = to_list(Msg),
    list_to_float(Msg2).

%% integer
to_integer(Msg) when is_integer(Msg) ->
    Msg;
to_integer(Msg) when is_binary(Msg) ->
    Msg2 = binary_to_list(Msg),
    list_to_integer(Msg2);
to_integer(Msg) when is_list(Msg) ->
    list_to_integer(Msg);
to_integer(_Msg) ->
    0.

%% tuple
to_tuple(T) when is_tuple(T) -> T;
to_tuple(T) -> {T}.

%% list2atom 优化
list_to_atom(List)->
    try
        erlang:list_to_existing_atom(List)
    catch _:_ ->
        erlang:list_to_atom(List)
    end.


%%%===================================================================
%%% 时间相关
%%%===================================================================

unixtime() ->
    {M, S, _Ms} = ?MODULE:now(),
    M * 1000000 + S.

now() ->
    os:timestamp().

%% 根据1970年以来的秒数获得日期
unixtime2localtime(Unixtime) ->
    Unixtime2= util:to_integer(Unixtime),
    DateTime = calendar:gregorian_seconds_to_datetime(Unixtime2 + ?diff_seconds_0000_1970),
    calendar:universal_time_to_local_time(DateTime).

date_format(D) ->
    case D < 10 of
        true -> "0" ++ to_list(D);
        false -> to_list(D)
    end.
