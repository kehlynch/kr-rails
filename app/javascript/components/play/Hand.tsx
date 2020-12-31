import React from "react";
import Card from "./Card";
import { CardType } from "../../types";
import styles from "../../styles/play/Hand.module.scss";

type HandProps = {
  cards: Array<CardType>;
};

const Hand = ({ cards }: HandProps): React.ReactElement => {
  return (
    <div className={styles.container}>
      { cards.map((c) => <Card hand slug={c.slug} key={c.slug} /> ) }
    </div>
  );
};

export default Hand;
