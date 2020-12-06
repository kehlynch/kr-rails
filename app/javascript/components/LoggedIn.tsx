import React, { useState, useEffect, useCallback } from "react";
import { Redirect } from "react-router-dom";

import { getPlayer } from "../api";
import { PlayerType } from "../types";

import NavBar from "./NavBar";

type LoggedInProps = {
  children: Array<React.ReactElement> | React.ReactElement
}

export default ( { children } : LoggedInProps): React.ReactElement => {
  const [[player, playerChecked], setPlayerStatus] = useState<[PlayerType | null, boolean]>([null, false]);
  const setPlayer = useCallback((p) => setPlayerStatus([p, true]), [
    setPlayerStatus,
  ]);
  useEffect(() => getPlayer(setPlayer), [setPlayer]);

  console.log("playerChecked", playerChecked);
  console.log("player", player);

  if (playerChecked && !player) {
    return <Redirect to="/login" />
  }

  return (
    <>
      <NavBar player={player} />
      { children }
    </>
  );
};
