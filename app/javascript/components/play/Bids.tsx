import React from "react";

import ContinueButton from "./ContinueButton";

import BidPicker from "./BidPicker";
import BidIndicators from "./BidIndicators";
import styles from "../../styles/play/Bids.module.scss";
import { AnnouncementSlug, BidSlug, AnnouncementType, BidType, Position } from "../../types";

export type BidsProps = {
  validBids: Array<BidSlug | AnnouncementSlug>,
  bids: Array<BidType | AnnouncementType>,
  myTurn: boolean,
  myPosition: Position,
  cont: null | (() => void),
  makeBid: ((arg: BidSlug & AnnouncementSlug) => void)
}

// type groupedBidsType = { [key in Position]: Array<BidSlug> };
type groupedBidsType = Array<Array<BidSlug | AnnouncementSlug>>;

const bidsByPosition = (bids: Array<BidType | AnnouncementType>): groupedBidsType => (
  bids.reduce((acc: groupedBidsType, bid) => {
    if(!acc[bid.playerPosition]) acc[bid.playerPosition] = [];
    acc[bid.playerPosition].push(bid.slug); // TODO ? should not be needed?
    return acc;
  }, [])
);

const Bids = ({ validBids, bids, myTurn, myPosition, cont, makeBid }: BidsProps): React.ReactElement => {
  console.log("bids", bids);
  return (
    <div className={styles.container}>
      { bidsByPosition(bids).map((slugs, position) => {
        console.log("position", position);
        console.log("myposition", myPosition);
        /* eslint-disable react/no-array-index-key */
        return (<BidIndicators slugs={slugs} key={`bids-${position}-${slugs.join(',')}`} position={(myPosition + position) % 4}/>)
        /* eslint-ebable react/no-array-index-key */
      })}
      <BidPicker validBids={validBids} canBid={myTurn} makeBid={makeBid} />
      { cont && (<ContinueButton  onclick={cont}/>) }
    </div>
  );
};

export default Bids;
