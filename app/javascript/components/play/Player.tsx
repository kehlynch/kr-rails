import React from "react";
import Waiting from "./Waiting";
import Role, { RoleType } from "./Role"
import { PlayerType } from "../../types";
import styles from "../../styles/play/Player.module.scss";

type PlayerProps = {
  player: PlayerType;
};

const Player = ({ player }: PlayerProps): React.ReactElement => {
  const {
    name,
    forehand,
    declarer,
    partner,
    announcements,
    nextToPlay,
  } = player;
  return (
    <>
      <div className={styles.playerNameContainer}>
        <span>hello{name}</span>
        {nextToPlay && <Waiting />}
      </div>
      <div>
        {forehand && <Role name={RoleType.FOREHAND} />}
        {declarer && <Role name={RoleType.DECLARER} />}
        {partner && <Role name={RoleType.PARTNER} />}
      </div>
      <div className={styles.playerAnnouncements}>{announcements}</div>
    </>
  );
};

export default Player;
