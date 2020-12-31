import React from "react";
import classNames from "classnames";
import { Position, BidSlug, AnnouncementSlug } from "../../types";
import { bidName } from "../../utils";
import styles from "../../styles/play/BidIndicators.module.scss";

type BidIndicatorsProps = {
  position: Position;
  slugs: Array<BidSlug | AnnouncementSlug>;
};


const COMPASS_CLASSES = [
 styles.south,
 styles.east,
 styles.north,
 styles.west,
]

const BidIndicators = ({ position, slugs }: BidIndicatorsProps): React.ReactElement => {
  const compassClass = COMPASS_CLASSES[position];
  console.log(position);
  console.log("compassclass", compassClass);

  return (
    <div className={classNames(styles.container, compassClass)} >
      { slugs.map((s) => <div className={styles.indicator} key={s}>{ bidName(s)} </div>) }
    </div>
  );
};

export default BidIndicators;
