:- ensure_loaded(display).
:- ensure_loaded(initial_state).
:- ensure_loaded(moves).

% play()
% Predicado para inicar o jogo, quando chamado sem argumentos pede ao utilizador que escolha o modo de jogo
play :-
    display_start_screen,
    display_start_menu(X),
    play(X).

% play_test_custom_board(+X)
% Predicado de jogo que permite começar a partir de um estado de jogo diferente do inicial (os indices condizem com os boardIndex definidos no fincheiro initial_state.pl)
play_test_custom_board(X):-
    board(X,GameState),
    display_game(10,GameState,1), !,
    game_cycle(GameState-1).

% play(+X)
% Predicado de jogo com argumento, o indice passado define o tipo de jogo
% Se for passado 1 no argumento inicia o jogo entre dois utilizadores
play(1):-
    initial_state(GameState),
    display_game(10,GameState,1), !,
    game_cycle(GameState-1).

% Se for passado 2 no argumento inicia o jogo entre utilizador e computador, antes de iniciar pede ao utilizador que escolha o nivel de dificuldade do AI
play(2):- 
    display_difficulty_menu(X),
    initial_state(GameState),
    display_game_ai(10,GameState,1), !,
    game_cycle_ai(GameState-1, X).

% Se for passado 3 no argumento inicia o jogo entre AI's, antes de iniciar pede ao utilizador que escolha o nivel de dificuldade dos AI's
play(3):-
    display_difficulty_menu_2(X, Y),
    initial_state(GameState),
    display_game_ai_2(10, GameState, 1), !,
    game_cycle_ai_2(GameState-1, X, Y).

% Outros inputs não são aceites
play(_):-
    display_clear,
    write('No more game modes.').

% ciclo de jogo normal entre dois utilizadores
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

% game_cycle_ai(+GameState-Player, +Dificulty)
% ciclo de jogo entre Jogador e Computador com determinada dificuldade
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

% game_cycle_ai_2(+GameState-Player, +Difficulty1, +Difficulty2)
% ciclo de jogo entre AI's com determinadas dificuldades independentes
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

% predicado auxiliar que devolve o indice do próximo jogador
next_player(Player, NextPlayer):-
    NextPlayer is (Player mod 2) + 1.