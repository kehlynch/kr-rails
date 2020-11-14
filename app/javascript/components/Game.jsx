import React, { useEffect } from "react";
import PropTypes from "prop-types";
// import Button from "react-bootstrap/Button";

// import MatchListing from "./MatchListing";
// import { destroySession, getOpenMatches } from "../api";

// import styles from "../styles/Game.module.scss";
import Players from "./play/Players";
import { GameType, PlayerType } from "../types";
import connect from "../channel";

const Game = ({ player, game, setGame }) => {
  const { id, players } = game;

  useEffect(() => connect(player.id, game.id, setGame));

  return (
    <div>
      Welcome to game {id}
      <Players players={players} />
    </div>
  );
};

Game.propTypes = {
  player: PlayerType,
  game: GameType,
  setGame: PropTypes.func,
};

export default Game;
