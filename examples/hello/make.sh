#!/bin/bash
export PATH=/d/apps/erl10.2/bin:${PATH}


escript rebar g-d
escript rebar co
