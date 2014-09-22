%%% -*- coding: latin-1 -*-

%%% The  contents of this  file are  subject to  the Erlang  Public License,
%%% Version  1.1, (the  "License");  you may  not  use this  file except  in
%%% compliance  with the License.  You should  have received  a copy  of the
%%% Erlang  Public License  along  with this  software.  If not,  it can  be
%%% retrieved at http://plc.inf.elte.hu/erlang/
%%%
%%% Software  distributed under  the License  is distributed  on an  "AS IS"
%%% basis, WITHOUT  WARRANTY OF ANY  KIND, either expressed or  implied. See
%%% the License  for the specific language governing  rights and limitations
%%% under the License.
%%%
%%% The Original Code is RefactorErl.
%%%
%%% The Initial Developer of the  Original Code is E�tv�s Lor�nd University.
%%% Portions created  by E�tv�s  Lor�nd University are  Copyright 2008-2009,
%%% E�tv�s Lor�nd University. All Rights Reserved.

%%% @doc Unit test for {@link reflib_token}.
%%% @author Laszlo Lovei <lovei@inf.elte.hu>

-module(reftest_reflib_token).
-vsn("$Rev: 5815 $").

-compile([export_all]).

-include("test.hrl").

files() ->
    [{header,"test.hrl",
      "-define(M(X), [X]).\n"},
     {module, "test.erl",
      "-module(test).\n"
      "f() ->\n"
      "  [1, 2].\n"
      "-include(\"test.hrl\").\n"
      "g() -> ?M(alma).\n"
      "-define(MM, ?M(1)).\n"
      "h() -> ?MM.\n"}].

test_virtuals() ->
    GB = ?Query:exec1(
            ?Query:seq([?Mod:find(test), ?Mod:local(g,0),
                        ?Fun:definition(), ?Form:clauses(),
                        ?Clause:body(1), [{elex,1}]]),
            test_br1),
    HB = ?Query:exec1(
            ?Query:seq([?Mod:find(test), ?Mod:local(h,0),
                        ?Fun:definition(), ?Form:clauses(),
                        ?Clause:body(1), [{elex,1}]]),
            test_br2),
    OB = ?Query:exec1(
            ?Query:seq([?File:find("test.hrl"), ?File:form(1),
                        [{flex, {type,'==',body}}, {llex, 1}]]),
            test_br0),
    L = lists:sort([GB, HB]),
    L = lists:sort(
          ?Query:exec(OB, ?Token:virtuals())),
    ok.

test_clause() ->
    Clause = ?Query:exec1(
                ?Query:seq([?Mod:find(test), ?Mod:local(f,0),
                            ?Fun:definition(), ?Form:clauses()]),
                test_clause),
    Arrow = ?Query:exec1(
             ?Query:seq(?File:find("test.erl"), ?File:token(20)),
             test_expr),
    [Clause] = ?Query:exec(Arrow, ?Token:clause()),
    ok.

test_form() ->
    Form = ?Query:exec1(
              ?Query:seq([?Mod:find(test), ?Mod:local(f,0), ?Fun:definition()]),
              test_form),
    Name = ?Query:exec1(
              ?Query:seq(?File:find("test.erl"), ?File:token(16)),
              test_name),
    [Form] = ?Query:exec(Name, ?Token:form()),
    ok.

test_file() ->
    Expr = ?Query:exec1(
              ?Query:seq([?File:find("test.erl"),
                          ?File:form(4), ?Form:clause(1), ?Clause:body(1)]),
              test_expr),
    Br = ?Query:exec1(Expr, [{elex,1}], test_bracket),
    Alma = ?Query:exec1(Expr,
                        ?Query:seq([?Expr:child(1), ?Expr:child(1), [elex]]),
              test_atom),
    M = ?Query:exec1(?File:find("test.erl"), test_mod),
    H = ?Query:exec1(?File:find("test.hrl"), test_hdr),
    [M] = ?Query:exec(Alma, ?Token:file()),
    [M] = ?Query:exec(Alma, ?Query:seq(?Token:original(), ?Token:file())),
    [M] = ?Query:exec(Br, ?Token:file()),
    [H] = ?Query:exec(Br, ?Query:seq(?Token:original(), ?Token:file())),
    ok.

test_pos() ->
    Arrow = ?Query:exec1(
               ?Query:seq([?Mod:find(test), ?Mod:local(f,0),
                           ?Fun:definition(),
                           ?Form:clause(1), [{clex,3}]]),
               test_fun),
    {20, 21} = ?Token:pos(Arrow),
    ok.

test_linecol() ->
    Arrow = ?Query:exec1(
               ?Query:seq([?Mod:find(test), ?Mod:local(f,0),
                           ?Fun:definition(),
                           ?Form:clause(1), [{clex,3}]]),
               test_fun),
    {{2,5}, {2,6}} = ?Token:linecol(Arrow),
    ok.

test_text() ->
    Arrow = ?Query:exec1(
               ?Query:seq([?Mod:find(test), ?Mod:local(f,0),
                           ?Fun:definition(),
                           ?Form:clause(1), [{clex,3}]]),
               test_fun),
    " ->\n" = ?Token:text(Arrow),
    ok.

test_data() ->
    Alma = ?Query:exec1(
              ?Query:seq([?Mod:find(test), ?Mod:local(g,0),
                          ?Fun:definition(),
                          ?Form:clause(1), ?Clause:body(1),
                          ?Expr:child(1), ?Expr:child(1),
                          [{elex,1}]]),
             test_expr),
    T = #token{type=atom} = ?Token:data(Alma),
    alma = ?Token:get_value(T),
    ok.

test_foldpos_find() ->
    File = ?Query:exec1(?File:find("test.erl"), test_file),
    First = ?Query:exec1(File,
                         ?Query:seq(?File:form(1), [{flex, 1}]), test_lex),
    %% ?File:token uses foldpos
    First = ?Query:exec1(File, ?File:token(1), find_error),
    Fn = ?Query:exec1(File,
                      ?Query:seq([?File:form(2),
                                  ?Form:clause(1),
                                  ?Clause:name(),
                                  [{elex,1}]]),
                      test_lex),
    %% ?File:token uses foldpos
    Fn = ?Query:exec1(File, ?File:token(16), find_error),
    ok.

test_expr() ->
    Bracket = ?Query:exec1(
                 ?Query:seq(?File:find("test.erl"),
                            ?File:token(25)),
                 test_file),
    Expr = ?Query:exec1(
              ?Query:seq([?Mod:find(test),
                          ?Mod:local(f,0),
                          ?Fun:definition(),
                          ?Form:clause(1),
                          ?Clause:body(1)]), test_expr),
    Expr = ?Query:exec1(Bracket, ?Token:expr(), expr_error),
    ok.
