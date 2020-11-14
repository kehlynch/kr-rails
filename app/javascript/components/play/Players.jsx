import React from "react";
import PropTypes from "prop-types";
import { PlayerType } from "../../types";

const Players = ({ players }) => {
  return <div>{players.map((player) => `player ID ${player.id}`)}</div>;
};

Players.propTypes = {
  players: PropTypes.arrayOf(PlayerType),
};

export default Players;
