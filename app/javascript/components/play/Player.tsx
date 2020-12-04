import React from "react";
// import PropTypes from "prop-types";
import Waiting from "./Waiting";
// @ts-ignore
import Role from "./Role.tsx";
// @ts-ignore
import { PlayerType } from "../../types";
import styles from "../../styles/play/Player.module.scss";

type PlayerProps = {
  player: PlayerType;
};

const Player = ({ player }: PlayerProps) => {
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
        <span>hello{name}</span>
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
