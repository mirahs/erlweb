%% -*- coding: latin-1 -*-
-module(controller_adm_home).

-compile(nowarn_export_all).
-compile(export_all).

-include("common.hrl").
-include("web.hrl").


welcome(_Method, _Req, _OPts) ->
    {output, "welcome"}.
