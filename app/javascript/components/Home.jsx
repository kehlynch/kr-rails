import React, { useState, useEffect } from "react";
import { getPlayer } from "../api";

import Login from "./Login";
import GameList from "./GameList";

export default () => {
  const [[player, playerChecked], setPlayer] = useState([null, false]);
  // const [game, setGame] = useState(nil);
  //
  useEffect(() => {
    getPlayer((p) => {
      setPlayer([p, true]);
    });
  }, []);

  return (
    <div>
      {!playerChecked && <div>loading...</div>}
      {player && <GameList player={player} />}
      {!player && playerChecked && (
        <Login
          setPlayer={(p) => {
            setPlayer([p, true]);
          }}
        />
      )}
    </div>
  );
};
