import React, { useState, useEffect, useCallback } from "react";
import Button from "react-bootstrap/Button";
import { Redirect } from "react-router-dom";

import { getMatch, gotoLastGame } from "../api";
import { connectToMatchesChannel } from "../channel";

import LoggedIn from "./LoggedIn";

import { MatchType } from "../types";

export default (): React.ReactElement => {
  const [[match, matchLoaded], loadMatch] = useState<[MatchType | null, boolean]>([null, false]);
  const setMatch = useCallback((g) => loadMatch([g, true]), [loadMatch]);

  const [game, setGame] = useState();

  useEffect(() => {
    if (!matchLoaded) {
      getMatch(setMatch);
    }
    if (matchLoaded) {
      if (match !== null) {
        connectToMatchesChannel(match.id, setMatch);
      }
    }
  }, [match, matchLoaded, setMatch]);

  if (!matchLoaded) {
    return <div>Loading...</div>
  }

  if (!match) {
    return <Redirect to="/" />
  }

  if (game) {
    return <Redirect to="/play" />
  }

  return (
    <LoggedIn>
      { match.players.length === 4 ? ( <Button onClick={() => gotoLastGame(match.id, setGame)}>Play</Button>) : ( <div>Waiting for players...</div>)}
    </LoggedIn>
  );
};
