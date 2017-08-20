-define(INFO(Format),			    xxweb_tool:info(Format, [], self(), ?MODULE, ?LINE)).
-define(INFO(Format, Args),			xxweb_tool:info(Format, Args, self(), ?MODULE, ?LINE)).

-define(ERR(Format),			    xxweb_tool:error(Format, [], self(), ?MODULE, ?LINE)).
-define(ERR(Format, Args),			xxweb_tool:error(Format, Args, self(), ?MODULE, ?LINE)).
