%% -*- coding: latin-1 -*-
-module(tbl_adm_user).

-export([
    get_by_account/1
]).

-include("common.hrl").


%%%===================================================================
%%% API
%%%===================================================================

get_by_account(Account) ->
    mysql:select_map_row(?db_admin, "SELECT * FROM `adm_user` WHERE `account`=?", [Account]).
