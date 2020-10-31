import React, { useState, useEffect, useCallback } from "react";
import Container from "react-bootstrap/Container";

import { getPlayer } from "../api";

import Login from "./Login";
import PlayerHome from "./PlayerHome";
import NavBar from "./NavBar";

export default () => {
  const [[player, playerChecked], setPlayerStatus] = useState([null, false]);
  // const [game, setGame] = useState(nil);
  //
  const setPlayer = useCallback((p) => setPlayerStatus([p, true]), [
    setPlayerStatus,
  ]);
  useEffect(() => getPlayer(setPlayer), [setPlayer]);

  return (
    <>
      <NavBar player={player} />
      <Container className={["mb-5", "mt-3"]}>
        {!playerChecked && <div>loading...</div>}
        {player && <PlayerHome player={player} setPlayer={setPlayer} />}
        {!player && playerChecked && <Login setPlayer={setPlayer} />}
      </Container>
    </>
  );
};
