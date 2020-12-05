import React, { useCallback, useEffect, useState } from "react";

import { getGame, getPlayer } from "../api";

import { GameType, PlayerType } from "../types";
import Players from "./play/Players";
import connect from "../channel";

const Game = (): React.ReactElement => {
  const [[game, gameLoaded], loadGame] = useState<[GameType | null, boolean]>([null, false]);
  const setGame = useCallback((g) => loadGame([g, true]), [loadGame]);
  const [[player, playerLoaded], loadPlayer] = useState<[PlayerType | null, boolean]>([null, false]);
  const setPlayer = useCallback((p) => loadPlayer([p, true]), [loadPlayer]);

  useEffect(() => {
    if (!gameLoaded) {
      getGame(setGame);
    }
    if (!playerLoaded) {
      getPlayer(setPlayer);
    }
    if (gameLoaded && playerLoaded) {
      if (player !== null && game !== null) {
        connect(player.id, game.id, setGame);
      }
    }
  }, [game, player, gameLoaded, playerLoaded, setGame, setPlayer]);

  return (
    <div>
      {gameLoaded && playerLoaded && game !== null && player !== null && (
        <div>
          <div>Welcome to game {game.id}</div>
          <Players players={game.players} />
        </div>
      )}
    </div>
  );
};

export default Game;
