import React from "react";
import Button from "react-bootstrap/Button";
import OverlayTrigger from 'react-bootstrap/OverlayTrigger'
import Tooltip from 'react-bootstrap/Tooltip'
import classNames from "classnames";

import { createMatch } from "../../api";

import styles from "../../styles/player_home/NewMatchSection.module.scss";

const buttonClassNames = [
  styles.oneHuman,
  styles.twoHuman,
  styles.threeHuman,
  styles.fourHuman,
]

type NewMatchSectionProps = {
  setMatch: Function
};

const NewMatchSection = ({setMatch}: NewMatchSectionProps): React.ReactElement => {
  console.log("setMatch", setMatch);
  return (
    <div className={styles.container}>
      <h2>New game</h2>
      { [...Array(4).keys()].map((i) => {
        const iconClass = buttonClassNames[i]
        const humanCount = i + 1;
        return (
          <OverlayTrigger
            key={i}
            placement="top"
            overlay={
              <Tooltip id={`tooltip-${i}-player-game`}>
                {humanCount} humans; {4 - humanCount} bots
              </Tooltip>
            }
          >
            <Button variant="primary" className={classNames(styles.newGameButton, iconClass)} onClick={() => createMatch(humanCount, setMatch)}/>
          </OverlayTrigger>
        )
      } )}
    </div>
  );
};

export default NewMatchSection;
