import React, { useState, useEffect } from "react";
import Container from "react-bootstrap/Container";
import classNames from "classnames";

import { getPlayer } from "../api";
import { PlayerType } from "../types";

import LoggedIn from "./LoggedIn";
import PlayerHome from "./PlayerHome";

export default (): React.ReactElement => {
  const [player, setPlayer] = useState<PlayerType | undefined>();
  useEffect(() => getPlayer(setPlayer), [setPlayer]);

  return (
    <LoggedIn>
      <Container className={classNames("mb-5", "mt-3")}>
        <PlayerHome player={player} />
      </Container>
    </LoggedIn>
  );
};
