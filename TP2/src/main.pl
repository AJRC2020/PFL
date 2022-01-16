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

play(1):-
    initial_state(GameState),
    display_game(10,GameState,1), !,
    game_cycle(GameState-1).
play(2):- 
    display_difficulty_menu(X),
    initial_state(GameState),
    display_game_ai(10,GameState,1), !,
    game_cycle_ai(GameState-1, X).
play(3):-
    display_difficulty_menu_2(X, Y),
    initial_state(GameState),
    display_game_ai_2(10, GameState, 1), !,
    game_cycle_ai_2(GameState-1, X, Y).
play(_):-
    display_clear,
    write('No more game modes.').

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

game_cycle_ai(GameState-Player, _):-
    game_over(GameState, Player), !,
    next_player(Player, Winner),
    congratulate_ai(Winner).
game_cycle_ai(GameState-1, Difficulty):-
    pick_move(GameState, 1, Move),
    move(GameState, Move, NewGameState),
    display_game_ai(10, NewGameState, 2),
    game_cycle_ai(NewGameState-2, Difficulty).
game_cycle_ai(GameState-2, Difficulty):-
    choose_move(GameState, Difficulty, Move, 2),
    move(GameState, Move, NewGameState),
    display_game_ai(10, NewGameState, 1),
    game_cycle_ai(NewGameState-1, Difficulty).

game_cycle_ai_2(GameState-Player, _, _):-
    game_over(GameState, Player), !,
    next_player(Player, Winner),
    congratulate_ai_2(Winner).
game_cycle_ai_2(GameState-Player, Difficulty1, Difficulty2):-
    choose_move(GameState, Difficulty1, Move, Player),
    move(GameState, Move, NewGameState),
    next_player(Player, NextPlayer),
    display_game_ai_2(10, NewGameState, NextPlayer), !,
    game_cycle_ai_2(NewGameState-NextPlayer, Difficulty1, Difficulty2).

% value(+GameState, +Player, -Value)
% Forma(s) de avaliação do estado do jogo do ponto de vista de um jogador
% value(GameState, Player, Value).

next_player(Player, NextPlayer):-
    NextPlayer is (Player mod 2) + 1.