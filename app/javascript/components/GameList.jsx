import React from "react";

import { PlayerType } from "../types";

const GameList = ({ player }) => {
  return <div>Welcome {player.name}</div>;
};

GameList.propTypes = {
  player: PlayerType,
};

export default GameList;
