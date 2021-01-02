import React from "react";

import ContinueButton from "./ContinueButton";
import Instruction from "./Instruction";

import { pickKing } from "../../api"

import Card from "./Card";
import styles from "../../styles/play/Kings.module.scss";

export type KingsProps = {
  myTurn: boolean,
  cont: null | (() => void),
  nextPlayerName: string | undefined
}

const Kings = ({  myTurn, cont, nextPlayerName }: KingsProps): React.ReactElement => {
  return (
    <div className={styles.container}>
      <div className={styles.instruction}>
        <Instruction
          text={cont ? 'king picked' : 'pick a king'}
          staticText={!!cont}
          myTurn={myTurn}
          nextPlayerName={nextPlayerName}
        />
      </div>
      <div className={styles.cardsContainer}>
        { Array.from(['heart_8', 'spade_8', 'diamond_8', 'club_8']).map((slug) => <Card slug={slug} key={slug} onclick={() => myTurn && pickKing(slug) }/>) }
      </div>
      { cont && (
        <div className={styles.continueButton}>
          <ContinueButton  onclick={cont}/>
        </div>
      ) }
    </div>
  );
};

export default Kings;
