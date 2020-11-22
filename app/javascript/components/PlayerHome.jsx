import React, { useState, useEffect } from "react";
import PropTypes from "prop-types";
import Button from "react-bootstrap/Button";

import MatchListing from "./MatchListing";
import { PlayerType } from "../types";
import { destroySession, getOpenMatches } from "../api";

import styles from "../styles/PlayerHome.module.scss";

const PlayerHome = ({ player, setPlayer, setGame }) => {
  const { name, points, gameCount, matches } = player;
  const [openMatches, setOpenMatches] = useState([]);

  useEffect(() => getOpenMatches(setOpenMatches), [setOpenMatches]);

  return (
    <div>
      <div className="d-flex justify-content-between align-items-start">
        <h2 className={styles.playerName}>{name}</h2>
        <Button
          variant="secondary"
          onClick={() => {
            destroySession(() => setPlayer(null));
          }}
        >
          Log out{" "}
        </Button>
      </div>
      <div className={styles.playerTotalPoints}>Scored {points} in total</div>

      <div className={styles.playerHandsPlayed}>Played {gameCount} hands</div>

      <h2 className="mb-4">My games</h2>
      {matches.length === 0 && (
        <div className="no-matches-text">You have not joined any games</div>
      )}
      <div className={styles.matchCardsContainer}>
        {matches.map((m) => (
          <MatchListing
            key={`mymatch-${m.id}`}
            matchListing={m}
            setGame={setGame}
            joined
          />
        ))}
      </div>

      <div>Welcome {player.name}</div>
      {openMatches.map((m) => (
        <MatchListing key={m.id} setGame={setGame} matchListing={m} />
      ))}
    </div>
  );
};

PlayerHome.propTypes = {
  player: PlayerType,
  setPlayer: PropTypes.func,
  setGame: PropTypes.func,
};

export default PlayerHome;
