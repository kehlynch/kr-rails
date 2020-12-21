import React from "react";
import Container from "react-bootstrap/Container";
import classNames from "classnames";

import { PlayerType } from "../types";

import NavBar from "./NavBar";
import PlayerHome from "./PlayerHome";

type HomeProps = {
  player: PlayerType;
}

export default (props: HomeProps): React.ReactElement => {
  const { player } = props;
  return (
    <>
      <NavBar player={player} />
      <Container className={classNames("mb-5", "mt-3")}>
        <PlayerHome player={player} />
      </Container>
    </>
  );
};
