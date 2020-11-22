import React from "react";
// import PropTypes from "prop-types";
import Waiting from "./Waiting";
import Role from "./Role.tsx";
import { PlayerType } from "../../types";
import styles from "../../styles/play/player.module.scss";

type PlayerProps = {
  player: PlayerType;
};

const Player = ({ player }: PlayerProps): React.node => {
  const {
    name,
    forehand,
    declarer,
    partner,
    announcements,
    nextToPlay,
  } = player;
  return (
    <div>
      <div className={styles.playerNameContainer}>
        <span>{name}</span>
        {nextToPlay && <Waiting />}
      </div>
      <div>
        {forehand && <Role name="forehand" />}
        {declarer && <Role name="declarer" />}
        {partner && <Role name="partner" />}
      </div>
      <div className={styles.playerAnnouncements}>{announcements}</div>
    </div>
  );
};

export default Player;
