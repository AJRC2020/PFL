:- ensure_loaded(display).


% display_game(+GameState)
% Recebendo o estado de jogo atual (que inclui o jogador que efetuará a próxima jogada) mostra o estado atual do tabuleiro
display_game(Size, GameState, Player):-
    display_clear,
    % print Size lines
    format('It`s Player ~d`s turn to play', Player),nl,
    write('Player 1`s pieces are X'),nl,
    write('Player 2`s pieces are O'),nl,
    nl,

    display_board(Size,GameState,0).

    

display_board(Size,GameState, N):-
    % line_division(Size),
    display_board(Size,GameState,Size, N).

display_board(_,_,0,_):- !.
display_board(Size,GameState,Index, N):-
    display_line(Size,GameState,N),nl,
    % line_division(Size),
    Index1 is Index - 1,
    N1 is N + Size,
    display_board(Size,GameState,Index1,N1).

display_line(Size,GameState,N):-
    display_line(Size,GameState,Size,N).

display_line(_,_,0,_):- write('*'), !.
display_line(Size,_,Size,_):- write('*|'), fail.
display_line(Size,GameState,Index,N):-
    display_piece(N,GameState),
    write('|'),
    Index1 is Index - 1,
    N1 is N +1,
    display_line(Size,GameState,Index1,N1).

line_division(Size):-
    write('*'),
    Num is Size*2 +1,
    write_n_times('-',Num),
    write('*'),
    nl.

write_n_times(_,0):-!.
write_n_times(S,N):-
    write(S),
    N1 is N - 1,
    write_n_times(S,N1).

display_piece(N, GameState):-
    select(S-_-N,GameState,_),!,
    write_piece_symbol(S).
display_piece(_,_):-
    write(' ').

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
display_start_menu_error(_) :-
    display_clear,
    write('Invalid input, choose a valid option.'),nl,
    write('Press Enter to continue: '),
    skip_line,
    fail.

write_piece_symbol(r):-write('X').
write_piece_symbol(b):-write('O').
