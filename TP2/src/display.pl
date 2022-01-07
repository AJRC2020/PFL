% display_game(+GameState)
display_game(GameState):-
    display_start_screen,
    display_start_menu(X),
    display_clear,
    write(X),nl,
    write(GameState).

display_clear :- write('\33\[2J').

display_start_screen :-
    display_clear,
    write('******************************************************'), nl,
    write('*      *****  *****  *****  *****  *      *****      *'), nl,
    write('*        *    *   *  *        *    *      *          *'), nl,
    write('*        *    *   *  *****    *    *      *****      *'), nl,
    write('*        *    *   *      *    *    *      *          *'), nl,
    write('*      ***    *****  *****    *    *****  *****      *'), nl,
    write('*                                                    *'), nl,
    write('*                                                    *'), nl,
    write('*      Design by Mark Steere                         *'), nl,
    write('*                                                    *'), nl,
    write('******************************************************'), nl,
    nl,
    write('Press any key to continue: '),
    skip_line.

display_start_menu(X) :-
    display_clear,
    write('******************************************************'), nl,
    write('*  1. Player vs Player                               *'), nl,
    write('*  2. Player vs AI                                   *'), nl,
    write('*  3. AI vs AI                                       *'), nl,
    write('*                                                    *'), nl,
    write('*                                                    *'), nl,
    write('*                                                    *'), nl,
    write('*                                                    *'), nl,
    write('*                                                    *'), nl,
    write('*                                                    *'), nl,
    write('******************************************************'), nl,
    nl,
    write('Choose an option (1-3): '),
    get_code(Input),
    skip_line,
    X is Input,
    display_start_menu_error(X).

display_start_menu_error(1).
display_start_menu_error(2).
display_start_menu_error(3).
display_start_menu_error(X) :-
    display_clear,
    write('Invalid input, choose a valid option.'),nl,
    write('Press any key to continue: '),
    skip_line,
    display_start_menu(X).
