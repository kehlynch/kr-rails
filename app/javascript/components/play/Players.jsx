import React from "react";
import PropTypes from "prop-types";
import Player from "./Player";
import { PlayerType } from "../../types";
// import styles from "../styles/play/Players.module.scss";

const Players = ({ players }) => {
  return (
    <div>
      {players.map((player) => (
        <Player player={player} key={player.id} />
      ))}
    </div>
  );
};

Players.propTypes = {
  players: PropTypes.arrayOf(PlayerType),
};

export default Players;
