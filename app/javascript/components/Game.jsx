import React, { useEffect, useState } from "react";
// import Button from "react-bootstrap/Button";

// import MatchListing from "./MatchListing";
import { getGame, getPlayer } from "../api";

// import styles from "../styles/Game.module.scss";
import Players from "./play/Players";
import connect from "../channel";

const Game = () => {
  const [game, setGame] = useState();
  const [player, setPlayer] = useState();

  useEffect(() => {
    if (!game) {
      getGame(setGame);
    }
    if (!player) {
      getPlayer(setPlayer);
    }
    if (!!game && !!player) {
      connect(player.id, game.id, setGame);
    }
  }, [game, player, setGame, setPlayer]);

  return (
    <div>
      {game && (
        <div>
          <div>Welcome to game {game.id}</div>
          <Players players={game.players} />
        </div>
      )}
    </div>
  );
};

export default Game;
