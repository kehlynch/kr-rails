import React, { useState, useEffect } from "react";
import { Redirect } from "react-router-dom";

import MatchListing from "./MatchListing";
import NewMatchSection from "./player_home/NewMatchSection";
import { PlayerListingType, MatchListingType } from "../types";
import { getOpenMatches } from "../api";

import styles from "../styles/PlayerHome.module.scss";


type PlayerProps = {
  player: PlayerListingType | undefined,
};

const PlayerHome = ({ player }: PlayerProps): React.ReactElement => {
  console.log("rendering playerhome player", player);
  const [openMatches, setOpenMatches] = useState<Array<MatchListingType>>([]);
  const [match, setMatch] = useState();

  useEffect(() => getOpenMatches(setOpenMatches), [setOpenMatches]);

  if (!player) {
    return <div>loading...</div>
  }

  if (match) {
    return <Redirect to="/match" />
  }


  const { name, points, gameCount, matches } = player;

  return (
    <div>
      <div className="d-flex justify-content-between align-items-start">
        <h2 className={styles.playerName}>{name}</h2>
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
            setMatch={setMatch}
            joined
          />
        ))}
      </div>

      <div>Welcome {player.name}</div>
      {openMatches.map((m) => (
        <MatchListing key={m.id} setMatch={setMatch} matchListing={m} />
      ))}
      <NewMatchSection setMatch={setMatch} />
    </div>
  );
};

export default PlayerHome;
