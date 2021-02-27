#!/bin/bash
export PATH=/d/apps/erl9.2/bin:${PATH}

escript rebar g-d
escript rebar co
