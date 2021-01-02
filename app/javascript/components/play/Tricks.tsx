import React from "react";
import classNames from "classnames";

import ContinueButton from "./ContinueButton";
import Instruction from "./Instruction";

import { TrickType, Position } from "../../types";
import { playCard, setViewedTrick } from "../../api"
import { compassName } from "../../utils"

import Card from "./Card";
import styles from "../../styles/play/Tricks.module.scss";

export type TricksProps = {
  myTurn: boolean,
  myPosition: Position,
  tricks: Array<TrickType>,
  nextPlayerName: string | undefined,
  lastViewedTrick: number,
  myPlayerId: number
}

const Tricks = ({  myTurn, myPosition, tricks, nextPlayerName, lastViewedTrick, myPlayerId }: TricksProps): React.ReactElement => {
  const visibleTrick = tricks.sort((t) => t.index).find((t) => t.index > lastViewedTrick ? 1 : -1 );

  if (!visibleTrick) {
    return <div>something went wrong</div>
  }

  const cont = visibleTrick.finished ? () => setViewedTrick(myPlayerId, lastViewedTrick + 1) : false;

  return (
    <div className={styles.container}>
      <div className={styles.instruction}>
        <Instruction
          text={cont ? 'trick finished' : 'play a card'}
          staticText={!!cont}
          myTurn={myTurn}
          nextPlayerName={nextPlayerName}
        />
      </div>
      <div className={styles.cardsContainer}>
        { visibleTrick.cards.map((c) => {
          const compass = compassName(c.playerPosition, myPosition);
          const compassStyle = styles[compass];
          return (
            <div className={classNames(styles.card, compassStyle)} key={c.slug}>
              <Card slug={c.slug} key={c.slug} onclick={() => myTurn && playCard(c.slug)} landscape={['east', 'west'].includes(compass)}/>
            </div>
          )
        })}
      </div>
      { cont && (
        <div className={styles.continueButton}>
          <ContinueButton  onclick={cont}/>
        </div>
      ) }
    </div>
  );
};

export default Tricks;
