:- ensure_loaded(display).
:- ensure_loaded(initial_state).
:- ensure_loaded(moves).
% play()
play :-
    display_start_screen,
    display_start_menu(X),
    play(X).

play(1) :-
    initial_state(GameState),
    display_game(10,GameState,1), !.
    % game_cycle(GameState-Player).

play(_):- 
    display_clear,
    write('Comming soon').


game_cycle(GameState-Player):-
    game_over(GameState, Player), !,
    congratulate(Winner).
game_cycle(GameState-Player):-
    choose_move(GameState, Player, Move),
    move(GameState, Move, NewGameState),
    next_player(Player, NextPlayer),
    display_game(GameState-NextPlayer), !,
    game_cycle(NewGameState-NextPlayer).


% game_over(+GameState, -Winner)
% Verificação da situação de fim do jogo, com identificação do vencedor
% game_over(GameState, Winner).

% value(+GameState, +Player, -Value)
% Forma(s) de avaliação do estado do jogo do ponto de vista de um jogador
% value(GameState, Player, Value).

% choose_move(+GameState, +Level, -Move)
% Escolha da jogada a efetuar pelo computador, dependendo do nível de dificuldade
% choose_move(GameState, Level, Move).
