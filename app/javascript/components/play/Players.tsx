import React from "react";
import Player from "./Player";
import { PlayerType, GamePlayerType } from "../../types";
// import styles from "../../styles/play/Players.module.scss";

type PlayersProps = {
  players: Array<GamePlayerType>,
  player: PlayerType,
  partnerId: number,
  partnerKnown: boolean,
  nextPlayerId: number,
  playCard: null | ((arg: string) => void)
}

const sortPlayers = (players: Array<GamePlayerType>, myPlayerId: number): Array<GamePlayerType> => {
  const myPlayerIndex = players.findIndex((p) => p.id === myPlayerId);
  return players.slice(myPlayerIndex).concat(players.slice(0, myPlayerIndex))
}

const Players = ({ players, player, partnerId, partnerKnown, nextPlayerId, playCard}: PlayersProps): React.ReactElement => {
  return (
    <>
      {sortPlayers(players, player.id).map((p, i) => {
        const me = p.id === player.id;
        const isPartner = p.id === partnerId;
        const displayPartner = isPartner && (me || partnerKnown); // slightly hacky - relying on sortPLayers to return me first

        return (
          <Player
            player={p}
            me={me}
            displayPartner={displayPartner}
            nextToPlay={p.id === nextPlayerId}
            position={i} key={p.id}
            playCard={playCard}
          />
        )
      })}
    </>
  );
};

export default Players;
