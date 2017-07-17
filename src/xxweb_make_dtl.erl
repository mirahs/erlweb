-module(xxweb_make_dtl).

-include("common.hrl").

-export([
	start/0
]).


%% erl -pa deps/xxweb/ebin deps/erlydtl/ebin -s xxweb_make_dtl -s init stop -extra ./src/templates
%% erl -pa deps/xxweb/ebin deps/erlydtl/ebin -s xxweb_make_dtl -s init stop -extra ./src/templates ./ebin
%% erl -pa deps/xxweb/ebin deps/erlydtl/ebin -s xxweb_make_dtl -s init stop -extra ./src/templates ./ebin  web_custom_tags
start() ->
	case init:get_plain_arguments() of
		[] ->
			make("./src/templates", "./ebin", ?undefined);
		[Dir] ->
			make(Dir, "./ebin", ?undefined);
		[Dir,OutDir] ->
			make(Dir, OutDir, ?undefined);
		[Dir,OutDir,CustomTags] ->
			make(Dir, OutDir, ?TOA(CustomTags))
	end.


make(Dir, OutDir, CustomTags) ->
	CompileArgs = ?IF(CustomTags =:= ?undefined, [{out_dir,OutDir}], [{out_dir,OutDir},{custom_tags_modules,[CustomTags]}]),
	{?ok, FileList} = file:list_dir(Dir),
	Fun = fun(FileBaseName) ->
				  case FileBaseName of
					  "base.html" ->
						  ?ok;
					  _ ->
						  FileName = Dir ++ "/" ++ FileBaseName,
						  case filelib:is_file(FileName) of
							  ?true ->
								  case filename:extension(FileBaseName) of
									  ".html" ->
										  RootName	= filename:rootname(FileBaseName),
										  RootNameA	= ?TOA(RootName),
										  %?MSG_ECHO("FileName : ~p RootNameA : ~p Opts : ~p~n", [FileName, RootNameA, Opts]),
										  erlydtl:compile_file(FileName, RootNameA, CompileArgs);
									  _ ->
										  ?skip
								  end;
							  _ ->
								  ?skip
						  end
				  end
		  end,
	lists:foreach(Fun, FileList),
	?ok.
