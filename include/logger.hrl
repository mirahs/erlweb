-define(INFO(Format),			    erlweb_tool:info(Format, [], self(), ?MODULE, ?LINE)).
-define(INFO(Format, Args),			erlweb_tool:info(Format, Args, self(), ?MODULE, ?LINE)).

-define(ERR(Format),			    erlweb_tool:error(Format, [], self(), ?MODULE, ?LINE)).
-define(ERR(Format, Args),			erlweb_tool:error(Format, Args, self(), ?MODULE, ?LINE)).
