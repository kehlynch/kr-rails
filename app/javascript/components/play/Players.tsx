import React from "react";
import classNames from "classnames";
import Player from "./Player";
import { PlayerType } from "../../types";
import styles from "../../styles/play/Players.module.scss";

type PlayersProps = {
  players: Array<PlayerType>,
  player: PlayerType
}

const COMPASS_CLASSES = [
  styles.south,
  styles.east,
  styles.north,
  styles.west
]

const sortPlayers = (players: Array<PlayerType>, myPlayerId: number): Array<PlayerType> => {
  const myPlayerIndex = players.findIndex((p) => p.id === myPlayerId);
  return players.slice(myPlayerIndex).concat(players.slice(0, myPlayerIndex))
}

const Players = ({ players, player }: PlayersProps): React.ReactElement => {
  console.log(sortPlayers(players, player.id));
  return (
    <>
      {sortPlayers(players, player.id).map((p, i) => (
        <div className={classNames(styles.playerContainer, COMPASS_CLASSES[i])} key={p.id}>
          <Player player={p} />
        </div>
      ))}
    </>
  );
};

export default Players;
