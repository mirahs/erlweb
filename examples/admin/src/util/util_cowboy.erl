%% -*- coding: latin-1 -*-
-module(util_cowboy).

-export([
    ip/1
]).

-include("common.hrl").


%%%===================================================================
%%% API
%%%===================================================================

ip(Req) ->
%%    ?DEBUG("cowboy_req:peer:~p", [cowboy_req:peer(Req)]),
%%    ?DEBUG("cowboy_req:header x-real-ip:~p", [cowboy_req:header(<<"x-real-ip">>, Req)]),
%%    ?DEBUG("cowboy_req:headers:~p", [cowboy_req:headers(Req)]),
    case cowboy_req:header(<<"x-real-ip">>, Req) of
        undefined ->
            {{Ip0, Ip1, Ip2, Ip3}, _Port} = cowboy_req:peer(Req),
            lists:concat([Ip0, ".", Ip1, ".", Ip2, ".", Ip3]);
        Ip -> util:to_list(Ip)
    end.
