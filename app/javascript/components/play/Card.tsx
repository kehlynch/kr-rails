import React from "react";
import classNames from "classnames";
import { CardType } from "../../types";
import styles from "../../styles/play/Card.module.scss";

type CardProps = {
  card: CardType,
  hand: boolean,
  pickable: boolean,
  legal: boolean,
};

const Card = ({ card, hand, pickable, legal }: CardProps): React.ReactElement => {
  const { slug } = card;
  const imagePath = `../../images/${slug}.jpg`;
  const onclick = () => console.log("clicked");
  return (
    <button type="button" onClick={onclick} className={classNames(styles.container, {[styles.hand]: hand})} >
    <img
      src={imagePath}
      alt={slug}
      className={classNames(styles.cardImage, {[styles.pickable]: pickable, [styles.illegal]: pickable && !legal})}
    />
    </button>
  );
};

export default Card;
