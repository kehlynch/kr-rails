import React from "react";

import ContinueButton from "./ContinueButton";

import Instruction from "./Instruction";
import BidPicker from "./BidPicker";
import BidIndicators from "./BidIndicators";
import styles from "../../styles/play/Bids.module.scss";
import { DeclarableSlug, DeclarableType, Position } from "../../types";

export type BidsProps = {
  declarableType: 'bid' | 'announcement',
  validBids: Array<DeclarableSlug>,
  bids: Array<DeclarableType>,
  myTurn: boolean,
  myPosition: Position,
  cont: false | (() => void),
  makeBid: ((arg: any) => void),
  nextPlayerName: string | undefined
}

// type groupedBidsType = { [key in Position]: Array<BidSlug> };
type groupedBidsType = Array<Array<DeclarableSlug>>;


const bidsByPosition = (bids: Array<DeclarableType>): groupedBidsType => (
  bids.reduce((acc: groupedBidsType, bid) => {
    if(!acc[bid.playerPosition]) acc[bid.playerPosition] = [];
    acc[bid.playerPosition].push(bid.slug); // TODO ? should not be needed?
    return acc;
  }, [])
);

const Bids = ({ declarableType, validBids, bids, myTurn, myPosition, cont, makeBid, nextPlayerName }: BidsProps): React.ReactElement => {
  const finishedText = declarableType === 'bid' ? 'bidding finished' : 'announcements finished';
  const actionText = declarableType === 'bid' ? 'make a bid' : 'make an announcement';
  return (
    <div className={styles.container}>
      <Instruction text={cont ? finishedText : actionText}
      staticText={!!cont} myTurn={myTurn} nextPlayerName={nextPlayerName} />
      { bidsByPosition(bids).map((slugs, position) => {
        /* eslint-disable react/no-array-index-key */
        return (<BidIndicators slugs={slugs} key={`bids-${position}-${slugs.join(',')}`} position={(myPosition + position) % 4}/>)
        /* eslint-ebable react/no-array-index-key */
      })}
      { !cont && <BidPicker validBids={validBids} canBid={myTurn} makeBid={makeBid} /> }
      { cont && (<ContinueButton  onclick={cont}/>) }
    </div>
  );
};

export default Bids;
