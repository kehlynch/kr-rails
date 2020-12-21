import React from "react";

import BidButton from "./BidButton";
import styles from "../../styles/play/BidPicker.module.scss";
import { bidName } from "../../utils";
import { BidSlug } from "../../types";

export type BidPickerProps = {
  validBids: Array<BidSlug>,
  canBid: boolean
}


const BidPicker = ({ validBids, canBid }: BidPickerProps): React.ReactElement => {
  return (
    <div className={styles.container}>
      { validBids.map((bidSlug) => (<BidButton name={bidName(bidSlug)} key={bidSlug} canBid={canBid} slug={bidSlug} />)) }
    </div>
  );
};

export default BidPicker;
