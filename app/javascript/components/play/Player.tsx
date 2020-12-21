import React from "react";
import classNames from "classnames";
import Waiting from "./Waiting";
import Role, { RoleType } from "./Role";
import Hand from "./Hand";
import { GamePlayerType } from "../../types";
import styles from "../../styles/play/Player.module.scss";

enum Position {
  South = 0,
  East = 1,
  North = 2,
  West = 3
}

type PlayerProps = {
  player: GamePlayerType;
  me: boolean;
  displayPartner: boolean;
  nextToPlay: boolean;
  position: Position;
};


const COMPASS_CLASSES = {
  [Position.South]: styles.south,
  [Position.East]: styles.east,
  [Position.North]: styles.north,
  [Position.West]: styles.west,
}

const Player = ({ player, me, displayPartner, nextToPlay, position }: PlayerProps): React.ReactElement => {
  const {
    name,
    forehand,
    declarer,
    cards,
    announcements,
  } = player;
  const compassClass = COMPASS_CLASSES[position];

  return (
    <div className={classNames(styles.container, compassClass)} >
      <div className={styles.playerDetailsContainer}>
        <div className={styles.playerNameContainer}>
          <span>{name}</span>
          {nextToPlay && <Waiting />}
        </div>
        <div>
          {forehand && <Role name={RoleType.FOREHAND} />}
          {declarer && <Role name={RoleType.DECLARER} />}
          {displayPartner && <Role name={RoleType.PARTNER} />}
        </div>
      </div>
      <div className={styles.playerAnnouncements}>{announcements}</div>
      { me && <Hand cards={ cards } />}
    </div>
  );
};

export default Player;
