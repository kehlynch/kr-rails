import React from "react";
import PropTypes from "prop-types";

import Button from "react-bootstrap/Button";
import { PlayerType } from "../types";
import { destroySession } from "../api";

const GameList = ({ player, setPlayer }) => {
  return (
    <div>
      <Button
        onClick={() => {
          destroySession(() => setPlayer(null));
        }}
      >
        Log out{" "}
      </Button>
      <div>Welcome {player.name}</div>
    </div>
  );
};

GameList.propTypes = {
  player: PlayerType,
  setPlayer: PropTypes.func,
};

export default GameList;
