:- use_module(library(lists)).
:- use_module(library(random)).


% move(+GameState, +From-To, -NewGameState)
% Execução de uma jogada, obtendo o novo estado do jogo
move(GameState, From-To, NewGameState):-
    select(C-I-From,GameState,Rest),
    append(Rest,[C-I-To], NewGameState).

% valid_moves(+GameState, -ListOfMoves, +PLayer)
% Obtenção da lista com as jogadas possíveis para um determinado jogador
valid_moves(GameState, ListOfMoves,1):-
    create_move_list(GameState, ListOfMoves, [], r,0),!.

valid_moves(GameState, ListOfMoves,2):-
    create_move_list(GameState, ListOfMoves, [], b,0),!.

% create_move_list(+GameState,-ListOfMoves,+List,+Player,+Index)
% Predicado auxiliar de valid_moves que cria a lista de jogadas com diferença de utilizar uma lista e indice auxiliares e o Player é um caracter 'r' ou 'b' em vez de um int (esta última é puramente uma questão de facilitar o acesso á lista de GameState)
%  Precorre as 16 peças do jogador e adiciona os movimentos possiveis de cada peça
create_move_list(_, ListOfMoves,ListOfMoves, _,16):-!.
create_move_list(GameState,ListOfMoves,List,Player,Index):-
    select(Player-Index-N,GameState,_),
    check_move(GameState,Player-_-N,L),
    append(List,L,List1),
    Index1 is Index + 1,
    create_move_list(GameState,ListOfMoves,List1,Player,Index1).


% check_move(+GameState, +Color-_-Position, ?List)
% Adiciona á lista List todas as jogadas possíveis para uma determinada peça tendo em conta a sua cor e posição
% Para tal utiliza outros 4 predicados auxiliares que fazem a verificação da jogada e, se permitido, adiciona á lista essa jogada
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

% Verifica a validade de um movimento de uma peça para a nova posição NewPos por comparação dos valores da peça na posição atual e nova posição
% Apenas jogadas que aumentem o valor de "orthogonal friendly connections" da peça (definido nas regras) são autorizadas
% check_move_validity(+GameState, +Color-_-OldPos, +NewPos)
check_move_validity(GameState,C-_-N, Pos):-
    \+ select(_-_-Pos,GameState,_),
    check_value(C-_-N,GameState,Value1),
    check_value(C-_-Pos,GameState,Value2),
    Value2 > Value1 + 1.


% Verifica o valor de uma determinada peça tendo em conta a sua cor e posição, o valor é posteriormente usado para determinar a validade de um movimento
% Utiliza outros 4 predicados auxiliares para fazer a verificação nas 4 direções ortogonais
% check_value(+Color-_-Position,+GameState,-Value)
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

check_value_left(_-_-N,_, Value):-
    N mod 10 < 1,!,
    Value is 0.
check_value_left(_-_-N,GameState, Value):-
    Pos is N-1,
    \+ select(_-_-Pos,GameState,_),!,
    Value is 0.

check_value_left(C-_-N,GameState, Value):-
    Pos is N-1,
    select(Color-_-Pos,GameState,_),
    check_color(C,Color,Value,0).

check_value_right(_-_-N,_, Value):-
    N mod 10 > 8,!,
    Value is 0.
check_value_right(_-_-N,GameState, Value):-
    Pos is N+1,
    \+select(_-_-Pos,GameState,_),!,
    Value is 0.

check_value_right(C-_-N,GameState, Value):-
    Pos is N+1,
    select(Color-_-Pos,GameState,_),
    check_color(C,Color,Value,0).

% check_color(+Color1,+Color2,-Value,+Old)
% Incrementa o valor de Old para Value se Color1 e Color2 forem iguais, senão decrementa
check_color(C,C,Value,Old):-
    Value is Old + 1, !.

check_color(_,_,Value,Old):-
    Value is Old - 1.


% game_over(+GameState, +Player)
% Verificação da situação de fim do jogo para o jogador da presente jogada (pelas regras do jogo assume-se a vitória do adversário se o jogador não tiver movimentos possíveis)
game_over(GameState, Player):-
    valid_moves(GameState,List,Player),
    \+ select(_-_,List,_).

% choose_move(+GameState, +Level, -Move, -Player)
% Escolha da jogada a efetuar pelo computador, dependendo do nível de dificuldade
choose_move(GameState, 1, Move, Player):-
    valid_moves(GameState, Moves, Player),
    random_select(Move, Moves, _).
choose_move(GameState, 2, Move, Player):-
    valid_moves(GameState, Moves, Player),
    best_move(Move, GameState, Moves, Player).


% value(+GameState, +Move, -Value)
% Forma(s) de avaliação do estado do jogo do ponto de vista de um jogador calculando o aumento de valor de uma peça após uma jogada
evaluate_move(GameState, From-To, Value):-
    select(C1-N1-From,GameState,Rest),
    check_value(C1-N1-From, GameState, Value1),
    move(GameState, From-To, NewGameState),
    select(C2-N2-To, NewGameState, Rest),
    check_value(C2-N2-To, NewGameState, Value2),
    Value is Value2 - Value1.

% value(+GameState, +Player, -Value)
% Calcula a soma do valor de ligações adjacentes de todas as peças de um jogador num certo estado de jogo
value(GameState, Player, Value):-
    value(GameState, Player, 0, Value, 0).
value(_,_,AuxValue, AuxValue,16):-!.
value(GameState, Player, AuxValue, RValue, Index):-
    select(Player-Index-Pos, GameState,_),
    check_value(Player-Index-Pos,GameState,Value1),
    Sum is AuxValue + Value1,
    Index1 is Index + 1,
    value(GameState,Player,Sum,RValue,Index1).

% best_move(-Move, +GameState, +Moves, +Player)
% escolhe o movimento do computador que tem o menor aumento do valor da peça, quanto menor o aumento mais jogadas deverá levar a ficar sem movimentos
best_move(Move, GameState, Moves, Player):-
    best_move(Move, GameState, Moves, 1000, _, Player).
best_move(Move, _, [], _, Move, _).
best_move(Move, GameState, [H|T], Min, _, Player):-
    evaluate_move(GameState, H, Value),
    Value < Min, !,
    best_move(Move, GameState, T, Value, H, Player).
best_move(Move, GameState, [_|T], Min, CurrentMove, _):-
    best_move(Move, GameState, T, Min, CurrentMove, _).