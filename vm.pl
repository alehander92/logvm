

eval(dup,       [Top | T],              [Top, Top | T],       Env, Env).
eval(pop,       [_ | T],                T,                    Env, Env).
eval(swap,      [First, Second | T],    [Second, First | T],  Env, Env).

eval(Number,    Stack,                  [Number | Stack],     Env, Env) :- 
    number(Number).

eval(reset,     _,                      [],                   Env, Env).

eval(+,         [First, Second | T],    [Result | T],         Env, Env) :-
    number(First), number(Second), Result is First + Second.

eval(-,         [First, Second | T],    [Result | T],         Env, Env) :-
    number(Second), number(First), Result is Second - First.

eval(*,         [First, Second | T],    [Result | T],         Env, Env) :-
    number(Second), number(First), Result is First * Second.

eval(/,         [First, Second | E],    [Result | E],         Env, Env) :-
    number(Second), number(First), Result is Second / First.

eval(call,      [Function | E],         H, Env, Env) :-
    atom(Function),
    extract(Env, Function, Block),
    eval_program('call', Block, E, H, Env, Env);
    eval_program('call', Function, E, H, Env, Env).


eval(ht,        [[H | T] | E],          [H, T | E],           Env, Env).
eval(swap13,    [F1, F2, F3 | E],       [F3, F2, F1 | E],     Env, Env).
eval(swap23,    [F1, F2, F3 | E],       [F1, F3, F2 | E],     Env, Env).
eval(swap24,    [F1, F2, F3, F4 | E],   [F1, F4, F3, F2 | E], Env, Env).
eval(is_nonempty,  [[H | T] | E],       [true, [H | T] | E],  Env, Env).
eval(is_nonempty,  [[] | E],            [false, [] | E],      Env, Env).
eval(dup2,      [F1, F2 | E],           [F1, F2, F2 | E],     Env, Env).
eval(while,     [Test, Block | E],      H, Env, Env) :-
    extract(Env, Test, U),
    eval_program('test', U, E, F, Env, Env),
    =(F, [true | F1]),
    extract(Env, Block, B),
    eval_program('block', B, F1, F2, Env, Env),
    eval(while, [U, B | F2], H, Env, Env);
    extract(Env, Test, U),
    eval_program('test', U, E, F, Env, Env),
    =(F, [false | H]).
eval(def,       [Function, Top | E],     E,        Env,     [(Function, Top) | Env]).
eval(append,    [Top, [H | T] | E],      [[Top, H | T] | E], Env, Env).
eval(append,    [Top, [] | E],           [[Top] | E],        Env, Env).
eval([],        Stack,                   [[] | Stack],       Env, Env).
eval([H | T],   Stack,                   [[H | T] | Stack],  Env, Env).
eval(Name,      Stack,                   [Name | Stack],     Env, Env) :- 
    atom(Name).

extract(_, [H | T], [H | T]).
extract([(Name, U) | _], Name, U).
extract([_ | T], Name, U) :- atom(Name), extract(T, Name, U).

eval_program(_, [], Final, Final, Env, Env).
eval_program(Program, [Top | T], BeforeStack, AfterStack, BeforeEnv, AfterEnv) :-
    eval(Top, BeforeStack, A, BeforeEnv, B),
    format("~w~t after ~w:~t ~w~n", [Program, Top, A]),
    eval_program(Program, T, A, AfterStack, B, AfterEnv).



s :- eval_program('Main',
    [
        % everton
        [[], swap13, swap, [ht, swap23, dup2, swap, call, swap24, append, swap13, swap], [is_nonempty], while, pop, pop],
        map,
        def,
        % we defined map(list, fun) here
        [dup, *],
        [2, 4],
        map,
        call
        % we use it like this
], [], _, [], _).


%% =(Square, [
%%     2,
%%     [dup, *],
%%     call
%% ]).
