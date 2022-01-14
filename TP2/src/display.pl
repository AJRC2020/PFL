

% display_game(+GameState)
% Recebendo o estado de jogo atual (que inclui o jogador que efetuará a próxima jogada) mostra o estado atual do tabuleiro
display_game(GameState):-
    display_clear.
    % construct board
    
    

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
    write('Press Enter to continue: '),
    skip_line.

display_start_menu(X) :-
    repeat,
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
    read(Input),
    skip_line,
    display_start_menu_error(Input),
    X is Input.

display_start_menu_error(1) :- !.
display_start_menu_error(2) :- !.
display_start_menu_error(3) :- !.
display_start_menu_error(X) :-
    display_clear,
    write('Invalid input, choose a valid option.'),nl,
    write('Press Enter to continue: '),
    skip_line,
    fail.
