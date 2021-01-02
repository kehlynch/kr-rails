import React from "react";
import classNames from "classnames";
import { CompassName, BidSlug, AnnouncementSlug } from "../../types";
import { bidName } from "../../utils";
import styles from "../../styles/play/BidIndicators.module.scss";

type BidIndicatorsProps = {
  compassName: CompassName;
  slugs: Array<BidSlug | AnnouncementSlug>;
};

const BidIndicators = ({ compassName, slugs }: BidIndicatorsProps): React.ReactElement => {
  const compassClass = styles[compassName];

  return (
    <div className={classNames(styles.container, compassClass)} >
      { slugs.map((s) => <div className={styles.indicator} key={s}>{ bidName(s)} </div>) }
    </div>
  );
};

export default BidIndicators;
