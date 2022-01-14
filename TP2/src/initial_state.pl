:- use_module(library(lists)).


% initial_state(+Size, -GameState)
% Devolve o estado inicial do jogo, assume um tabuleiro quadrado com largura mínima de 10.
initial_state(GameState):-
    % add 15 red pieces to the GameState list
    append([],[r-0-22,r-1-24,r-2-26,r-3-33,r-4-35,r-5-37,r-6-42,r-7-46,r-8-53,r-9-57,r-10-62,r-11-64,r-12-66,r-13-73,r-14-75,r-15-77],List),
    % add 15 blue pieces to the GameState list
    append(List,[b-0-23,b-1-25,b-2-27,b-3-32,b-4-34,b-5-36,b-6-43,b-7-47,b-8-52,b-9-56,b-10-63,b-11-65,b-12-67,b-13-72,b-14-74,b-15-76],GameState).




construct_board(Size, Board):-
    construct_board(Size,[],Board, Size).
construct_board(_, List, List, 0):- !.
construct_board(Size, List, Board, Index) :-
    Index1 is Index - 1,
    make_row(Size,Element),
    construct_board(Size, [Element|List],Board,Index1).


make_row(Size,Row):- make_row(Size,[],Row).
make_row(0,List,List):-!.
make_row(Size,List,Row):-
    Size1 is Size - 1,
    make_row(Size1,[' '|List],Row).
