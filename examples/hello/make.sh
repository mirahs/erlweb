#!/bin/bash
export PATH=/d/apps/erl7.3/bin:${PATH}

escript rebar g-d
escript rebar co
