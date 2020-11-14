import React from "react";
// import PropTypes from "prop-types";
// import Button from "react-bootstrap/Button";

// import MatchListing from "./MatchListing";
import { GameType } from "../types";
// import { destroySession, getOpenMatches } from "../api";

// import styles from "../styles/Game.module.scss";

const Game = ({ game }) => {
  const { id } = game;

  return <div>Welcome to game {id}</div>;
};

Game.propTypes = {
  game: GameType,
};

export default Game;
