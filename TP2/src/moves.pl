:- use_module(library(lists)).
:- use_module(library(random)).


% move(+GameState, +Move, -NewGameState)
% Validação e execução de uma jogada, obtendo o novo estado do jogo
move(GameState, From-To, NewGameState):-
    select(C-I-From,GameState,Rest),
    append(Rest,[C-I-To], NewGameState).

% valid_moves(+GameState, -ListOfMoves, +PLayer)
% Obtenção de lista com jogadas possíveis
valid_moves(GameState, ListOfMoves,1):-
    create_move_list(GameState, ListOfMoves, [], r,0).

valid_moves(GameState, ListOfMoves,2):-
    create_move_list(GameState, ListOfMoves, [], b,0).

create_move_list(_, ListOfMoves,ListOfMoves, _,16):-!.
create_move_list(GameState,ListOfMoves,List,Player,Index):-
    select(Player-Index-N,GameState,_),
    check_move(GameState,Player-_-N,L),
    append(List,L,List1),
    Index1 is Index + 1,
    create_move_list(GameState,ListOfMoves,List1,Player,Index1).


check_move(GameState,C-_-N,List):-
    check_move_up(GameState,C-_-N,L1),
    check_move_down(GameState,C-_-N,L2),
    check_move_left(GameState,C-_-N,L3),
    check_move_right(GameState,C-_-N,L4),
    append(L1,L2,LS),
    append(L3,L4,LF),
    append(LS,LF,List).

check_move_up(_,_-_-N,_):-
    N < 10,!.
check_move_up(GameState,C-_-N,List):-
    N1 is N-10,
    \+ check_move_validity(GameState,C-_-N,N1),!,
    append([],[],List).
check_move_up(_,_-_-N,List):-
    N1 is N-10,
    append([],[N-N1],List).

check_move_down(_,_-_-N,_):-
    N > 89,!.
check_move_down(GameState,C-_-N,List):-
    N1 is N+10,
    \+ check_move_validity(GameState,C-_-N,N1),!,
    append([],[],List).
check_move_down(_,_-_-N,List):-
    N1 is N+10,
    append([],[N-N1],List).

check_move_left(_,_-_-N,_):-
    N mod 10 < 1,!.
check_move_left(GameState,C-_-N,List):-
    N1 is N-1,
    \+ check_move_validity(GameState,C-_-N,N1),!,
    append([],[],List).

check_move_left(_,_-_-N,List):-
    N1 is N-1,
    append([],[N-N1],List).

check_move_right(_,_-_-N,_):-
    N mod 10 > 8,!.
check_move_right(GameState,C-_-N,List):-
    N1 is N+1,
    \+ check_move_validity(GameState,C-_-N,N1),!,
    append([],[],List).

check_move_right(_,_-_-N,List):-
    N1 is N+1,
    append([],[N-N1],List).

check_move_validity(GameState,C-_-N, Pos):-
    \+ select(_-_-Pos,GameState,_),
    check_value(C-_-N,GameState,Value1),
    check_value(C-_-Pos,GameState,Value2),
    Value2 > Value1 + 1.

check_value(C-_-N,GameState, Value):-
    check_value_up(C-_-N,GameState,Value1),
    check_value_down(C-_-N,GameState,Value2),
    check_value_left(C-_-N,GameState,Value3),
    check_value_right(C-_-N,GameState,Value4),
    Value is Value1 + Value2 + Value3 + Value4.
    
check_value_up(_-_-N,GameState, Value):-
    Pos is N-10,
    \+ select(_-_-Pos,GameState,_),!,
    Value is 0.

check_value_up(C-_-N,GameState, Value):-
    Pos is N-10,
    select(Color-_-Pos,GameState,_),
    check_color(C,Color,Value,0).

check_value_down(_-_-N,GameState, Value):-
    Pos is N+10,
    \+ select(_-_-Pos,GameState,_),!,
    Value is 0.

check_value_down(C-_-N,GameState, Value):-
    Pos is N+10,
    select(Color-_-Pos,GameState,_),
    check_color(C,Color,Value,0).

check_value_left(_-_-N,GameState, Value):-
    Pos is N-1,
    \+ select(_-_-Pos,GameState,_),!,
    Value is 0.

check_value_left(C-_-N,GameState, Value):-
    Pos is N-1,
    select(Color-_-Pos,GameState,_),
    check_color(C,Color,Value,0).

check_value_right(_-_-N,GameState, Value):-
    Pos is N+1,
    \+select(_-_-Pos,GameState,_),!,
    Value is 0.

check_value_right(C-_-N,GameState, Value):-
    Pos is N+1,
    select(Color-_-Pos,GameState,_),
    check_color(C,Color,Value,0).

check_color(C,C,Value,Old):-
    Value is Old + 1, !.

check_color(_,_,Value,Old):-
    Value is Old - 1.


% game_over(+GameState, -Winner)
% Verificação da situação de fim do jogo, com identificação do vencedor
game_over(GameState, Player):-
    valid_moves(GameState,List,Player),
    \+ select(_-_,List,_).

% choose_move(+GameState, +Level, -Move)
% Escolha da jogada a efetuar pelo computador, dependendo do nível de dificuldade
choose_move(GameState, 1, Move, Player):-
    valid_moves(GameState, Moves, Player),
    random_select(Move, Moves, _).
choose_move(GameState, 2, Move, Player):-
    valid_moves(GameState, Moves, Player),
    best_move(Move, GameState, Moves, Player).


% value(+GameState, +Move, -Value)
% Forma(s) de avaliação do estado do jogo do ponto de vista de um jogador
value(GameState, From-To, Value):-
    select(C1-N1-From,GameState,Rest),
    check_value(C1-N1-From, GameState, Value1),
    move(GameState, From-To, NewGameState),
    select(C2-N2-To, NewGameState, Rest),
    check_value(C2-N2-To, NewGameState, Value2),
    Value is Value2 - Value1.

best_move(Move, GameState, Moves, Player):-
    best_move(Move, GameState, Moves, 1000, _, Player).
best_move(Move, _, [], _, Move, _).
best_move(Move, GameState, [H|T], Min, _, Player):-
    value(GameState, H, Value),
    Value < Min, !,
    best_move(Move, GameState, T, Value, H, Player).
best_move(Move, GameState, [_|T], Min, CurrentMove, _):-
    best_move(Move, GameState, T, Min, CurrentMove, _).