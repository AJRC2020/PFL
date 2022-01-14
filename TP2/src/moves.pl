% valid_moves(+GameState, -ListOfMoves)
% Obtenção de lista com jogadas possíveis
valid_moves(GameState, ListOfMoves):-
    createMoveList(GameState, ListOfMoves, []).

createMoveList([], ListOfMoves, ListOfMoves):-!.
createMoveList([C-I-N|T],ListOfMoves,List):-

% move(+GameState, +Move, -NewGameState)
% Validação e execução de uma jogada, obtendo o novo estado do jogo
move(GameState, Move, NewGameState):-
    


checkValue(C-_-N,GameState, Value):-
    checkValueUp(C-_-N,GameState,Value1),
    checkValueDown(C-_-N,GameState,Value2),
    checkValueLeft(C-_-N,GameState,Value3),
    checkValueRight(C-_-N,GameState,Value4),
    Value is Value1 + Value2 + Value3 + Value4.
    
checkValueUp(C-_-N,GameState, Value):-
    Pos is N-10,
    \+ select(Color-_-Pos,GameState,_),!,
    Value is 0.

checkValueUp(C-_-N,GameState, Value):-
    Pos is N-10,
    select(Color-_-Pos,GameState,_),
    check_color(C,Color,Value,0).

checkValueDown(C-_-N,GameState, Value):-
    Pos is N+10,
    \+ select(Color-_-Pos,GameState,_),!,
    Value is 0.

checkValueDown(C-_-N,GameState, Value):-
    Pos is N+10,
    select(Color-_-Pos,GameState,_),
    check_color(C,Color,Value,0).

checkValueLeft(C-_-N,GameState, Value):-
    Pos is N-1,
    \+ select(Color-_-Pos,GameState,_),!,
    Value is 0.

checkValueLeft(C-_-N,GameState, Value):-
    Pos is N-1,
    select(Color-_-Pos,GameState,_),
    check_color(C,Color,Value,0).

checkValueRight(C-_-N,GameState, Value):-
    Pos is N+1,
    \+select(Color-_-Pos,GameState,_),!,
    Value is 0.

checkValueRight(C-_-N,GameState, Value):-
    Pos is N+1,
    select(Color-_-Pos,GameState,_),
    check_color(C,Color,Value,0).

check_color(C,C,Value,Old):-
    Value is Old + 1, !.

check_color(_,_,Value,Old):-
    Value is Old - 1.
