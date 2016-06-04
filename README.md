# logvm

a interpreter for a joy-like concatenative stack-based language implemented as a prolog dsl:

```prolog
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
```
