#!/bin/bash
export PATH=/d/apps/erl7.3/bin:${PATH}

escript rebar g-d
\cp deps/erlweb/patch/cowboy_req.erl deps/cowboy/src
escript rebar co
