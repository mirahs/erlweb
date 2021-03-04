%% -*- coding: latin-1 -*-
-module(util).

-export([
    cn/2
    ,md5/1

    ,to_atom/1
    ,to_list/1
    ,to_binary/1
    ,to_float/1
    ,to_integer/1
    ,to_tuple/1
    ,list_to_atom/1

    ,cowboy_ip/1
]).

-include("common.hrl").


%%%===================================================================
%%% API
%%%===================================================================

%% 在控制台显示带中文的字符串
cn(Format, Args) ->
    io:format("~ts", [iolist_to_binary(io_lib:format(Format, Args))]).

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
%%% cowboy
%%%===================================================================

cowboy_ip(Req) ->
%%    ?DEBUG("cowboy_req:peer:~p", [cowboy_req:peer(Req)]),
%%    ?DEBUG("cowboy_req:header x-real-ip:~p", [cowboy_req:header(<<"x-real-ip">>, Req)]),
%%    ?DEBUG("cowboy_req:headers:~p", [cowboy_req:headers(Req)]),
    case cowboy_req:header(<<"x-real-ip">>, Req) of
        undefined ->
            {{Ip0, Ip1, Ip2, Ip3}, _Port} = cowboy_req:peer(Req),
            lists:concat([Ip0, ".", Ip1, ".", Ip2, ".", Ip3]);
        Ip -> to_list(Ip)
    end.
