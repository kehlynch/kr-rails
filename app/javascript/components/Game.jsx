import React, { useCallback, useEffect, useState } from "react";
// import Button from "react-bootstrap/Button";

// import MatchListing from "./MatchListing";
import { getGame, getPlayer } from "../api";

// import styles from "../styles/Game.module.scss";
import Players from "./play/Players";
import connect from "../channel";

const Game = () => {
  const [[game, gameLoaded], loadGame] = useState([null, false]);
  const setGame = useCallback((g) => loadGame([g, true]), [loadGame]);
  const [[player, playerLoaded], loadPlayer] = useState([null, false]);
  const setPlayer = useCallback((p) => loadPlayer([p, true]), [loadPlayer]);

  useEffect(() => {
    if (!gameLoaded) {
      getGame(setGame);
    }
    if (!playerLoaded) {
      getPlayer(setPlayer);
    }
    if (gameLoaded && playerLoaded) {
      connect(player.id, game.id, setGame);
    }
  }, [game, player, gameLoaded, playerLoaded, setGame, setPlayer]);

  return (
    <div>
      {gameLoaded && playerLoaded && (
        <div>
          <div>Welcome to game {game.id}</div>
          <Players players={game.players} />
        </div>
      )}
    </div>
  );
};

export default Game;
