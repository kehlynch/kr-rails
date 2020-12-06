import React, { useCallback, useEffect, useState } from "react";
import { Redirect } from "react-router-dom";

import { connectToPlayersChannel } from "../channel";

import { getGame } from "../api";

import Board from "./play/Board";
import NavBar from "./NavBar";
import { GameType, PlayerType } from "../types";

type GameProps = {
  player: PlayerType
}

const Game = ({ player }: GameProps): React.ReactElement => {
  const [[game, gameLoaded], loadGame] = useState<[GameType | null, boolean]>([null, false]);
  const setGame = useCallback((g) => loadGame([g, true]), [loadGame]);

  useEffect(() => {
    if (!gameLoaded) {
      getGame(setGame);
    }

    if (player !== null && game !== null) {
      connectToPlayersChannel(player.id, game.id, setGame);
    }
  }, [game, player, gameLoaded, setGame]);

  if (!gameLoaded || !player) {
    return <div>loading...</div>
  }

  if (!game) {
    return <Redirect to="/" />
  }

  return (
    <>
      <NavBar player={player} />
      <Board game={game} player={player} />
    </>
  );
};

export default Game;
