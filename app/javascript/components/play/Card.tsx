import React from "react";

import Button from "react-bootstrap/Button"
import classNames from "classnames";
import styles from "../../styles/play/Card.module.scss";

type CardProps = {
  slug: string,
  hand?: boolean,
  pickable?: boolean,
  legal?: boolean,
  onclick?: Function,
  landscape?: boolean
};

const Card = ({ slug, hand, pickable, legal, onclick, landscape = false }: CardProps): React.ReactElement => {
  const imagePath = landscape ?  `../../images/${slug}_landscape.jpg` : `../../images/${slug}.jpg`;

  return (
    <Button type="button" onClick={() => onclick && onclick()} className={classNames(styles.container, {[styles.hand]: hand, [styles.landscape]: landscape})} >
    <img
      src={imagePath}
      alt={slug}
      className={classNames(styles.cardImage, {[styles.pickable]: pickable, [styles.illegal]: pickable && !legal})}
    />
    </Button>
  );
};

export default Card;
