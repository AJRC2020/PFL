% play()
play().

% display_game(+GameState)
display_game(GameState).

% initial_state(+Size, -GameState)
initial_state(Size, GameState).

% move(+GameState, +Move, -NewGameState)
move(+GameState, Move, NewGameState).

% game_over(+GameState, -Winner)
game_over(+GameState, Winner).

% valid_moves(+GameState, -ListOfMoves)
valid_moves(+GameState, ListOfMoves).

% value(+GameState, +Player, -Value)
value(+GameState, Player, Value).

% choose_move(+GameState, +Level, -Move)
choose_move(GameState, Level, Move).
