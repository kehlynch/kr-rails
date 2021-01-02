import React from "react";

import Players from "./Players";
import Bids from "./Bids";
import Card from "./Card";
import Kings from "./Kings";
import Tricks from "./Tricks";
import styles from "../../styles/play/Board.module.scss";

import { setViewedBids, setViewedKings, setViewedAnnouncements, makeBid, makeAnnouncement, playCard, putdownCard } from "../../api";
import { GameType, GamePlayerType, Stage } from "../../types";

export type BoardProps = {
  game: GameType | undefined,
  player: GamePlayerType | undefined
}

const renderStage = (game: GameType, player: GamePlayerType) => {
  const { kingRequired, announcementsRequired, talonRequired,announcements, gamePlayers, nextGamePlayerId, stage, validAnnouncements, validBids, bids, tricks } = game

  const { viewedBids, viewedKings, viewedTalon, viewedAnnouncements, viewedTrickIndex } = player;

  console.log('viewedTrickIndex', viewedTrickIndex);

  const myTurn = player.id === nextGamePlayerId;
  const nextPlayerName = gamePlayers.find((p) => p.id === nextGamePlayerId)?.name;
  if (stage === Stage.Bid || !viewedBids) {
        return (
      <Bids
        declarableType='bid'
        bids={bids}
        cont={stage !== Stage.Bid ? () => setViewedBids(player.id) : false}
        makeBid={makeBid}
        myPosition={player.position}
        myTurn={myTurn}
        nextPlayerName={nextPlayerName}
        validBids={validBids}
      /> )
  } if (stage === Stage.King || (kingRequired && !viewedKings)) { return (
      <Kings
        myTurn={myTurn}
        cont={stage !== Stage.King ? () => setViewedKings(player.id) : null}
        nextPlayerName={nextPlayerName}
      /> )
  } if (stage === Stage.PickTalon || stage === Stage.ResolveTalon || (talonRequired && !viewedTalon)) { return (
    <div>Talon</div>
  )
  } if (stage === Stage.Announcement || (announcementsRequired && !viewedAnnouncements)) { return (
      <Bids
        declarableType='announcement'
        bids={announcements}
        cont={stage !== Stage.Announcement ? () => setViewedAnnouncements(player.id) : false}
        makeBid={makeAnnouncement}
        myPosition={player.position}
        myTurn={myTurn}
        nextPlayerName={nextPlayerName}
        validBids={validAnnouncements}
      /> )
  } if (stage === Stage.Trick || viewedTrickIndex < 11) {
    return (
      <Tricks
        tricks={tricks}
        myPosition={player.position}
        myTurn={myTurn}
        myPlayerId={player.id}
        nextPlayerName={nextPlayerName}
        lastViewedTrick={viewedTrickIndex === false ? -1 : viewedTrickIndex }
      /> )
  } if (stage === Stage.Finished) {
    return ( <div >score</div> )
  }
    return ( <div >why foes ts think I need this</div> )
}

const playCardCallback = (stage: Stage): null | ((arg: string) => void) => {
  switch (stage) {
    case Stage.ResolveTalon:
      return (slug) => putdownCard(slug)
    case Stage.Trick:
      return (slug) => playCard(slug)
    default:
      return null
  }

}


const Board = ({ player, game }: BoardProps): React.ReactElement => {
  if (game === undefined || player === undefined) {
    return <div>loading...</div>
  }

  console.log("game", game);

  const { stage, gamePlayers, partnerId, partnerKnown, nextGamePlayerId, king
, wonBid} = game;

  return (
    <div className={styles.container}>
      { king && <div className={styles.kingIndicator} >
        <Card slug={king} />
      </div> }
      { wonBid && <div className={styles.wonBidIndicator} >
        <p>{wonBid}</p>
      </div> }

      <div>Welcome to game {game.id}</div>
      { renderStage(game, player) }
      <Players players={gamePlayers} player={player} partnerId={partnerId} partnerKnown={partnerKnown} nextPlayerId={nextGamePlayerId} playCard={playCardCallback(stage)} />

    </div>
  );
};

export default Board;
