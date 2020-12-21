import React from "react";

import Players from "./Players";
import Instruction from "./Instruction";
import Bids from "./Bids";
import styles from "../../styles/play/Board.module.scss";

import { setViewedBids } from "../../api";
import { GameType, GamePlayerType, Stage } from "../../types";

export type BoardProps = {
  game: GameType | undefined,
  player: GamePlayerType | undefined
}


const Board = ({ player, game }: BoardProps): React.ReactElement => {
  if (game === undefined || player === undefined) {
    return <div>loading...</div>
  }

  console.log("game", game);

  const { gamePlayers, partnerId, partnerKnown, nextGamePlayerId, stage, validBids, bids } = game;

  const { viewedBids } = player;

  const myTurn = player.id === nextGamePlayerId;
  const nextPlayerName = gamePlayers.find((p) => p.id === nextGamePlayerId)?.name;

  return (
    <div className={styles.container}>
      <div>Welcome to game {game.id}</div>
      <Instruction viewedBids={viewedBids} stage={stage} myTurn={myTurn} nextPlayerName={nextPlayerName} />
      { ( stage === Stage.Bid || !viewedBids ) &&
      <Bids
        validBids={validBids}
        bids={bids}
        myTurn={myTurn}
      myPosition={player.position}
      cont={stage !== Stage.Bid ? () => setViewedBids(player.id) : null}
      /> }
      <Players players={gamePlayers} player={player} partnerId={partnerId} partnerKnown={partnerKnown} nextPlayerId={nextGamePlayerId} />
    </div>
  );
};

export default Board;
