import React from "react";

import BidButton from "./BidButton";
import styles from "../../styles/play/BidPicker.module.scss";
import { bidName } from "../../utils";
import { AnnouncementSlug, BidSlug } from "../../types";

export type BidPickerProps = {
  validBids: Array<BidSlug | AnnouncementSlug>,
  canBid: boolean,
  makeBid: ((arg: BidSlug | AnnouncementSlug) => void)
}


const BidPicker = ({ validBids, canBid, makeBid }: BidPickerProps): React.ReactElement => {
  return (
    <div className={styles.container}>
      { validBids.map((slug) => (<BidButton name={bidName(slug)} key={slug} onclick={() => canBid && makeBid(slug)} />)) }
    </div>
  );
};

export default BidPicker;
