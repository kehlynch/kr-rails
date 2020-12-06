import React, { useCallback, useEffect, useState } from "react";
import { Redirect } from "react-router-dom";

import { getGame, getPlayer } from "../api";

import LoggedIn from "./LoggedIn";
import Players from "./play/Players";
import { connectToPlayersChannel } from "../channel";
import { GameType, PlayerType } from "../types";


const Game = (): React.ReactElement => {
  const [player, setPlayer] = useState<PlayerType | null>(null);
  const [[game, gameLoaded], loadGame] = useState<[GameType | null, boolean]>([null, false]);
  const setGame = useCallback((g) => loadGame([g, true]), [loadGame]);

  useEffect(() => {
    if (!gameLoaded) {
      getGame(setGame);
    }

    getPlayer(setPlayer)

    if (player !== null && game !== null) {
      connectToPlayersChannel(player.id, game.id, setGame);
    }
  }, [game, player, gameLoaded, setGame, setPlayer]);

  if (!gameLoaded) {
    return <div>loading...</div>
  }

  if (!game) {
    return <Redirect to="/" />
  }

  return (
    <LoggedIn>
      <div>Welcome to game {game.id}</div>
      <Players players={game.players} />
    </LoggedIn>
  );
};

export default Game;
