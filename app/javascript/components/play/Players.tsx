import React from "react";
import Player from "./Player";
import { PlayerType } from "../../types";
// import styles from "../../styles/play/Players.module.scss";

type PlayersProps = {
  players: Array<PlayerType>,
  player: PlayerType,
  partnerId: number,
  partnerKnown: boolean,
  nextPlayerId: number
}

const sortPlayers = (players: Array<PlayerType>, myPlayerId: number): Array<PlayerType> => {
  const myPlayerIndex = players.findIndex((p) => p.id === myPlayerId);
  return players.slice(myPlayerIndex).concat(players.slice(0, myPlayerIndex))
}

const Players = ({ players, player, partnerId, partnerKnown, nextPlayerId }: PlayersProps): React.ReactElement => {
  return (
    <>
      {sortPlayers(players, player.id).map((p, i) => {
        const me = p.id === player.id;
        const isPartner = p.id === partnerId;
        const displayPartner = isPartner && (me || partnerKnown); // slightly hacky - relying on sortPLayers to return me first

        return (
          <Player player={p} me={me} displayPartner={displayPartner} nextToPlay={p.id === nextPlayerId} position={i} key={p.id}/>
        )
      })}
    </>
  );
};

export default Players;
