%% -*- coding: latin-1 -*-
-module(tbl_adm_user).

-export([
    get_by_account/1
    ,update_password_by_account/2
]).

-include("common.hrl").


%%%===================================================================
%%% API
%%%===================================================================

get_by_account(Account) ->
    mysql:select_map_row(?db_admin, "SELECT * FROM `adm_user` WHERE `account`=?", [Account]).

update_password_by_account(Account, Password) ->
    mysql:update(?db_admin, adm_user, [{password, Password}], "`account`=?", [Account]).
