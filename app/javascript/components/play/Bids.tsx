import React from "react";

import Button from "react-bootstrap/Button";

import BidPicker from "./BidPicker";
import BidIndicators from "./BidIndicators";
import styles from "../../styles/play/Bids.module.scss";
import { BidSlug, BidType, Position } from "../../types";

export type BidsProps = {
  validBids: Array<BidSlug>,
  bids: Array<BidType>,
  myTurn: boolean,
  myPosition: Position,
  cont: Function | null
}

// type groupedBidsType = { [key in Position]: Array<BidSlug> };
type groupedBidsType = Array<Array<BidSlug>>;

const bidsByPosition = (bids: Array<BidType>): groupedBidsType => (
  bids.reduce((acc: groupedBidsType, bid) => {
    if(!acc[bid.playerPosition]) acc[bid.playerPosition] = [];
    acc[bid.playerPosition].push(bid.slug); // TODO ? should not be needed?
    return acc;
  }, [])
);

const Bids = ({ validBids, bids, myTurn, myPosition, cont }: BidsProps): React.ReactElement => {
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
      <BidPicker validBids={validBids} canBid={myTurn} />
      { cont && (<Button className={styles.continueButton} variant="primary" onClick={() => cont()}>Continue</Button>) }
    </div>
  );
};

export default Bids;
