:- ensure_loaded(display).
% play()
play :-
    display_start_screen,
    % display_start_menu(X).
    % initial_state(Size, GameState),
    % display_game(GameState),




% initial_state(+Size, -GameState)
% Recebe o tamanho do tabuleiro como argumento e devolve o estado inicial do jogo
initial_state(0, GameState):- !.
initial_state(Size, GameState):-
    GameState is [[]],
    initial_state(Size,GameState, 0).
initial_state(Size, GameState, Index) :-
    Size =:= Index, !,
    append(GameState,[],GameState),
    Index is Index + 1,
    initial_state(Size1, GameState, Index).


make_rows(0,Row).
make_rows(Size,Row):-
    make_rows()
    append(Row,0,Row),
    Size1 is Size-1,
    make_rows(Size1,Row).
% move(+GameState, +Move, -NewGameState)
% Validação e execução de uma jogada, obtendo o novo estado do jogo
% move(GameState, Move, NewGameState).

% game_over(+GameState, -Winner)
% Verificação da situação de fim do jogo, com identificação do vencedor
% game_over(GameState, Winner).

% valid_moves(+GameState, -ListOfMoves)
% Obtenção de lista com jogadas possíveis
% valid_moves(GameState, ListOfMoves).

% value(+GameState, +Player, -Value)
% Forma(s) de avaliação do estado do jogo do ponto de vista de um jogador
% value(GameState, Player, Value).

% choose_move(+GameState, +Level, -Move)
% Escolha da jogada a efetuar pelo computador, dependendo do nível de dificuldade
% choose_move(GameState, Level, Move).
