#!/bin/bash
mod="pe$(basename $0)"
mod="$(echo ${mod} | sed 's/\.sh$//')"
erlc "${mod}.erl"
erl -run "${mod}" -run init stop -noshell