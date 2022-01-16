:- ensure_loaded(moves).


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

    
display_game_ai(Size, GameState, 1):-
    display_clear,
    write('It`s the Player`s turn to play'), nl,
    write('The Player`s pieces are X'),nl,
    write('The AI`s pieces are O'),nl,
    nl,
    display_board(Size, GameState, 0).
display_game_ai(Size, GameState, 2):-
    display_clear,
    write('You played your turn.'),nl,
    write('The Player`s pieces are X'),nl,
    write('The AI`s pieces are O'),nl,
    nl, 
    display_board(Size, GameState, 0),
    nl,
    write('Press Enter for AI turn: '),
    skip_line.   

display_game_ai_2(Size, GameState, Player):-
    display_clear,
    format('It`s AI ~d`s turn to play', Player),nl,
    write('AI 1`s pieces are X'),nl,
    write('AI 2`s pieces are O'),nl,
    nl,
    display_board(Size,GameState,0),
    nl,
    write('Press Enter for AI turn: '),
    skip_line.   

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

write_piece_symbol(r):-write('X').
write_piece_symbol(b):-write('O').

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

congratulate(Winner):-
    display_clear,
    write('******************************************************'), nl,
    write('*        *   *  *****  *   *  *****  ****   *        *'), nl,
    write('*        *   *    *    **  *  *      *   *  *        *'), nl,
    write('*        * * *    *    * * *  ***    ****   *        *'), nl,
    write('*        ** **    *    *  **  *      *  *            *'), nl,
    write('*        *   *  *****  *   *  *****  *   *  *        *'), nl,
    write('*                                                    *'), nl,
   format('*              Congratulations Player ~d!             *',Winner), nl,
    write('*                       You Won !                    *'), nl,
    write('*                                                    *'), nl,
    write('******************************************************').

pick_move(GameState, Player, Move):-
    repeat,
    valid_moves(GameState,ListOfMoves,Player),
    write('The following list contains the pairs of positions From-To that you can choose to move:'),nl,
    write(ListOfMoves),nl,
    write('Pick a pair of positons for your move (eg. 22-12): '),
    read(Move),
    skip_line,
    pick_move_error(Move,ListOfMoves,GameState,Player).

pick_move_error(From-To, ListOfMoves,_,_):-
    select(From-To,ListOfMoves,_),!.
pick_move_error(_-_,_,GameState,Player):-
    write('Sorry, invalid move.'),nl,
    write('Press Enter and try again: '),
    skip_line,
    display_game(10,GameState,Player),
    fail.

congratulate_ai(1):-
    display_clear,
    write('******************************************************'), nl,
    write('*        *   *  *****  *   *  *****  ****   *        *'), nl,
    write('*        *   *    *    **  *  *      *   *  *        *'), nl,
    write('*        * * *    *    * * *  ***    ****   *        *'), nl,
    write('*        ** **    *    *  **  *      *  *            *'), nl,
    write('*        *   *  *****  *   *  *****  *   *  *        *'), nl,
    write('*                                                    *'), nl,
    write('*                Congratulations Player              *'), nl,
    write('*                       You Won !                    *'), nl,
    write('*                                                    *'), nl,
    write('******************************************************').

congratulate_ai(2):-
    display_clear,
    write('******************************************************'), nl,
    write('*        *   *  *****  *   *  *****  ****   *        *'), nl,
    write('*        *   *    *    **  *  *      *   *  *        *'), nl,
    write('*        * * *    *    * * *  ***    ****   *        *'), nl,
    write('*        ** **    *    *  **  *      *  *            *'), nl,
    write('*        *   *  *****  *   *  *****  *   *  *        *'), nl,
    write('*                                                    *'), nl,
    write('*                   Congratulations AI               *'), nl,
    write('*                       You Won !                    *'), nl,
    write('*                                                    *'), nl,
    write('******************************************************').

display_difficulty_menu(X) :-
    repeat,
    display_clear,
    write('******************************************************'), nl,
    write('*  AI Difficulty level                               *'), nl,
    write('*  1. Basic                                          *'), nl,
    write('*  2. Hard                                           *'), nl,
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
    display_difficulty_menu_error(Input),
    X is Input.

display_difficulty_menu_error(1) :- !.
display_difficulty_menu_error(2) :- !.
display_difficulty_menu_error(_) :-
    display_clear,
    write('Invalid input, choose a valid option.'),nl,
    write('Press Enter to continue: '),
    skip_line,
    fail.

display_difficulty_menu_2(X, Y) :-
    repeat,
    display_clear,
    write('******************************************************'), nl,
    write('*  AI Difficulty level                               *'), nl,
    write('*  1. Basic                                          *'), nl,
    write('*  2. Hard                                           *'), nl,
    write('*                                                    *'), nl,
    write('*                                                    *'), nl,
    write('*                                                    *'), nl,
    write('*                                                    *'), nl,
    write('*                                                    *'), nl,
    write('*                                                    *'), nl,
    write('******************************************************'), nl,
    nl,
    write('Pick a pair of difficulties for the AIs (eg. 1-1): '),
    read(Input1-Input2),
    skip_line,
    display_difficulty_menu_error(Input1),
    display_difficulty_menu_error(Input2),
    X is Input1,
    Y is Input2.



congratulate_ai_2(Winner):-
    display_clear,
    write('******************************************************'), nl,
    write('*        *   *  *****  *   *  *****  ****   *        *'), nl,
    write('*        *   *    *    **  *  *      *   *  *        *'), nl,
    write('*        * * *    *    * * *  ***    ****   *        *'), nl,
    write('*        ** **    *    *  **  *      *  *            *'), nl,
    write('*        *   *  *****  *   *  *****  *   *  *        *'), nl,
    write('*                                                    *'), nl,
   format('*                Congratulations AI ~d!              *',Winner), nl,
    write('*                       You Won !                    *'), nl,
    write('*                                                    *'), nl,
    write('******************************************************').