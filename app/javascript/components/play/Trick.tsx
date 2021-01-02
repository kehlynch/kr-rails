import React from "react";
import classNames from "classnames";

import Instruction from "./Instruction";

import { TrickType, Position } from "../../types";
import { playCard, setViewedTrick } from "../../api"
import { compassName } from "../../utils"

import Card from "./Card";
import styles from "../../styles/play/Trick.module.scss";

export type TrickProps = {
  myTurn: boolean,
  myPosition: Position,
  trick: TrickType,
  nextPlayerName: string | undefined,
  myPlayerId: number
}

const Trick = ({  myTurn, myPosition, trick, nextPlayerName, myPlayerId }: TrickProps): React.ReactElement => {

  const { cards, finished, index } = trick;

  const cont = finished ? () => setViewedTrick(myPlayerId, index) : false;

  return (
    <div className={styles.container}>
      <div className={styles.instruction}>
        <Instruction
          text={cont ? 'trick finished' : 'play a card'}
          staticText={!!cont}
          myTurn={myTurn}
          nextPlayerName={nextPlayerName}
          cont={cont}
        />
      </div>
      <div className={styles.cardsContainer}>
        { cards.map((c) => {
          const compass = compassName(c.playerPosition, myPosition);
          const compassStyle = styles[compass];
          return (
            <div className={classNames(styles.card, compassStyle)} key={c.slug}>
              <Card slug={c.slug} key={c.slug} onclick={() => myTurn && playCard(c.slug)} landscape={['east', 'west'].includes(compass)}/>
            </div>
          )
        })}
      </div>
    </div>
  );
};

export default Trick;
