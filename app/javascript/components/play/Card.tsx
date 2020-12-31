import React from "react";

import Button from "react-bootstrap/Button"
import classNames from "classnames";
import styles from "../../styles/play/Card.module.scss";

type CardProps = {
  slug: string,
  hand?: boolean,
  pickable?: boolean,
  legal?: boolean,
  onclick?: Function
};

const Card = ({ slug, hand, pickable, legal, onclick}: CardProps): React.ReactElement => {
  const imagePath = `../../images/${slug}.jpg`;
  return (
    <Button type="button" onClick={() => onclick && onclick()} className={classNames(styles.container, {[styles.hand]: hand})} >
    <img
      src={imagePath}
      alt={slug}
      className={classNames(styles.cardImage, {[styles.pickable]: pickable, [styles.illegal]: pickable && !legal})}
    />
    </Button>
  );
};

export default Card;
