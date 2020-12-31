import React from "react";

import ContinueButton from "./ContinueButton";
import { pickKing } from "../../api"

import Card from "./Card";
import styles from "../../styles/play/Kings.module.scss";

export type KingsProps = {
  myTurn: boolean,
  cont: null | (() => void)
}

const Kings = ({  myTurn, cont }: KingsProps): React.ReactElement => {
  return (
    <div className={styles.container}>
      <div className={styles.cardsContainer}>
        { Array.from(['heart_8', 'spade_8', 'diamond_8', 'club_8']).map((slug) => <Card slug={slug} key={slug} onclick={() => myTurn && pickKing(slug) }/>) }
      </div>
      { cont && (<ContinueButton  onclick={cont}/>) }
    </div>
  );
};

export default Kings;
