import React from "react";

import Players from "./Players";
import Instruction from "./Instruction";
import Bids from "./Bids";
import Kings from "./Kings";
import styles from "../../styles/play/Board.module.scss";

import { getStageNumber } from "../../utils";
import { setViewedBids, setViewedKings, setViewedAnnouncements, makeBid, makeAnnouncement } from "../../api";
import { GameType, GamePlayerType, Stage, StageNumber } from "../../types";

export type BoardProps = {
  game: GameType | undefined,
  player: GamePlayerType | undefined
}


const Board = ({ player, game }: BoardProps): React.ReactElement => {
  if (game === undefined || player === undefined) {
    return <div>loading...</div>
  }

  console.log("game", game);

  const { announcements, gamePlayers, partnerId, partnerKnown, nextGamePlayerId, stage, validAnnouncements, validBids, bids } = game;

  const { viewedBids, viewedKings, viewedAnnouncements } = player;

  const stageNumber = getStageNumber(stage);

  const myTurn = player.id === nextGamePlayerId;
  const nextPlayerName = gamePlayers.find((p) => p.id === nextGamePlayerId)?.name;

  return (
    <div className={styles.container}>
      <div>Welcome to game {game.id}</div>
      <Instruction viewedBids={viewedBids} viewedKings={viewedKings} stage={stage} myTurn={myTurn} nextPlayerName={nextPlayerName} />
      { ( stage === Stage.Bid || !viewedBids ) &&
      <Bids
        makeBid={makeBid}
        validBids={validBids}
        bids={bids}
        myTurn={myTurn}
        myPosition={player.position}
        cont={stage !== Stage.Bid ? () => setViewedBids(player.id) : null}
      /> }
      { ( stage === Stage.King || (stageNumber >= StageNumber.King && !viewedKings )) &&
      <Kings
        myTurn={myTurn}
        cont={stage !== Stage.King ? () => setViewedKings(player.id) : null}
      /> }
      { ( stage === Stage.Announcement || (stageNumber >= StageNumber.Announcement && !viewedAnnouncements )) &&
      <Bids
        validBids={validAnnouncements}
        bids={announcements}
        myTurn={myTurn}
        myPosition={player.position}
        makeBid={makeAnnouncement}
        cont={stage !== Stage.Bid ? () => setViewedBids(player.id) : null}
      /> }
      <Players players={gamePlayers} player={player} partnerId={partnerId} partnerKnown={partnerKnown} nextPlayerId={nextGamePlayerId} />
    </div>
  );
};

export default Board;
