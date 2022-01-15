:- ensure_loaded(display).
:- ensure_loaded(initial_state).
:- ensure_loaded(moves).
% play()
play :-
    display_start_screen,
    display_start_menu(X),
    play(X).

play_test_custom_board(X):-
    board(X,GameState),
    display_game(10,GameState,1), !,
    game_cycle(GameState-1).

play(1) :-
    initial_state(GameState),
    display_game(10,GameState,1), !,
    game_cycle(GameState-1).

play(_):- 
    display_clear,
    write('Comming soon').


game_cycle(GameState-Player):-
    game_over(GameState, Player), !,        % if game_over Player loses
    next_player(Player,Winner),             % get winning Player
    congratulate(Winner).
game_cycle(GameState-Player):-
    pick_move(GameState, Player, Move),     % ask user desired move
    move(GameState, Move, NewGameState),
    next_player(Player, NextPlayer),
    display_game(10,NewGameState,NextPlayer), !,
    game_cycle(NewGameState-NextPlayer).



% value(+GameState, +Player, -Value)
% Forma(s) de avaliação do estado do jogo do ponto de vista de um jogador
% value(GameState, Player, Value).

% choose_move(+GameState, +Level, -Move)
% Escolha da jogada a efetuar pelo computador, dependendo do nível de dificuldade
% choose_move(GameState, Level, Move).

next_player(Player, NextPlayer):-
    NextPlayer is (Player mod 2) + 1.