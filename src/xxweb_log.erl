-module(xxweb_log).

-include("common.hrl").

-export([
		 error/2
		]).


error(Format, Args) ->
	?MSG_ECHO(Format, Args).
