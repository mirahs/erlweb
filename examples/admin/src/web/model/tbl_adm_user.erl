%% -*- coding: latin-1 -*-
-module(tbl_adm_user).

-export([
    get/1
    ,get_by_account/1
    ,delete/1
    ,update/2
    ,update_by_account/2
]).

-include("common.hrl").


%%%===================================================================
%%% API
%%%===================================================================

get(Id) ->
    mysql:select_map_row(?db_admin, "SELECT * FROM `adm_user` WHERE `id`=?", [Id]).

get_by_account(Account) ->
    mysql:select_map_row(?db_admin, "SELECT * FROM `adm_user` WHERE `account`=?", [Account]).

delete(Id) ->
    mysql:delete(?db_admin, adm_user, "`id`=?", [Id]).

update(Id, Data) ->
    mysql:update(?db_admin, adm_user, Data, "`id`=?", [Id]).

update_by_account(Account, Data) ->
    mysql:update(?db_admin, adm_user, Data, "`account`=?", [Account]).
