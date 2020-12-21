import React, { useCallback, useEffect, useState } from "react";
import { Redirect } from "react-router-dom";

/* eslint-disable */
// @ts-ignore
import { ActionCableConsumer } from '@thrash-industries/react-actioncable-provider';
/* eslint-enable */

import { getGame } from "../api";

import Board from "./play/Board";
import NavBar from "./NavBar";
import { GameType, PlayerType } from "../types";
import styles from "../styles/Game.module.scss";

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

    // if (player !== null && game !== null) {
    //   connectToGamesChannel(game.id, setGame);
    // }
  }, [game, player, gameLoaded, setGame]);

  if (!gameLoaded || !player) {
    return <div>loading...</div>
  }

  if (!game) {
    return <Redirect to="/" />
  }

  return (
    <ActionCableConsumer
      channel={{channel: "GameChannel", id: game.id}}
      onReceived={(data: any) => {console.log('received from channel', data); setGame(data.game)}}
      >
      <NavBar player={player} />
      <div className={styles.gameContainer}>
        <Board game={game} player={game.gamePlayers.find((p) => p.playerId === player.id)} />
      </div>
    </ActionCableConsumer>
  );
};

export default Game;
