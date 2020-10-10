import React, { useState, useEffect, useCallback } from "react";
import { getPlayer } from "../api";

import Login from "./Login";
import GameList from "./GameList";

export default () => {
  const [[player, playerChecked], setPlayerStatus] = useState([null, false]);
  // const [game, setGame] = useState(nil);
  //
  const setPlayer = useCallback((p) => setPlayerStatus([p, true]), [
    setPlayerStatus,
  ]);
  useEffect(() => getPlayer(setPlayer), [setPlayer]);

  return (
    <div>
      {!playerChecked && <div>loading...</div>}
      {player && <GameList player={player} setPlayer={setPlayer} />}
      {!player && playerChecked && <Login setPlayer={setPlayer} />}
    </div>
  );
};
