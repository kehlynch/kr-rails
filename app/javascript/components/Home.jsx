import React, { useState, useEffect, useCallback } from "react";
import Container from "react-bootstrap/Container";

import { getPlayer } from "../api";

import NavBar from "./NavBar";
import Login from "./Login";
import PlayerHome from "./PlayerHome";
import Game from "./Game";

export default () => {
  const [[player, playerChecked], setPlayerStatus] = useState([null, false]);
  const setPlayer = useCallback((p) => setPlayerStatus([p, true]), [
    setPlayerStatus,
  ]);
  const [game, setGame] = useState();
  useEffect(() => getPlayer(setPlayer), [setPlayer]);

  return (
    <>
      <NavBar player={player} />
      <Container className={["mb-5", "mt-3"]}>
        {!playerChecked && <div>loading...</div>}
        {!player && playerChecked && <Login setPlayer={setPlayer} />}
        {player && !game && (
          <PlayerHome player={player} setPlayer={setPlayer} setGame={setGame} />
        )}
        {player && game && <Game game={game} />}
      </Container>
    </>
  );
};
