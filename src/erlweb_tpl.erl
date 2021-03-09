%% -*- coding: latin-1 -*-
-module(erlweb_tpl).

-export([
    init/0
    ,assign/2
    ,get/0
    ,destroy/0
]).

-include("erlweb.hrl").

-define(dict_erlweb_tpl_data,   dict_erlweb_tpl_data).


%%%===================================================================
%%% API
%%%===================================================================

init() ->
    erlang:put(?dict_erlweb_tpl_data, []).

assign(Key, Value) ->
    Data = erlang:get(?dict_erlweb_tpl_data),
    DataN=
        case lists:keytake(Key, 1, Data) of
            {value, {Key, _}, DataTmp} -> [{Key, Value} | DataTmp];
            false -> [{Key, Value} | Data]
        end,
    erlang:put(?dict_erlweb_tpl_data, DataN).

get() ->
    erlang:get(?dict_erlweb_tpl_data).

destroy() ->
    erlang:erase(?dict_erlweb_tpl_data).
