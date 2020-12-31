import React from "react";

import ContinueButton from "./ContinueButton";

import AnnouncementPicker from "./AnnouncementPicker";
import BidIndicators from "./BidIndicators";
import styles from "../../styles/play/Announcements.module.scss";
import { AnnouncementSlug, AnnouncementType, Position } from "../../types";

export type AnnouncementsProps = {
  validAnnouncements: Array<AnnouncementSlug>,
  announcements: Array<AnnouncementType>,
  myTurn: boolean,
  myPosition: Position,
  cont: null | (() => void)
}

// type groupedBidsType = { [key in Position]: Array<BidSlug> };
type groupedAnnouncementsType = Array<Array<AnnouncementSlug>>;

const announcementsByPosition = (announcements: Array<AnnouncementType>): groupedAnnouncementsType => (
  announcements.reduce((acc: groupedAnnouncementsType, announcement) => {
    if(!acc[announcement.playerPosition]) acc[announcement.playerPosition] = [];
    acc[announcement.playerPosition].push(announcement.slug); // TODO ? should not be needed?
    return acc;
  }, [])
);

const Announcements = ({ validAnnouncements, announcements, myTurn, myPosition, cont }: AnnouncementsProps): React.ReactElement => {
  console.log("announcements", announcements);
  return (
    <div className={styles.container}>
      { announcementsByPosition(announcements).map((slugs, position) => {
        console.log("position", position);
        console.log("myposition", myPosition);
        /* eslint-disable react/no-array-index-key */
        return (<BidIndicators slugs={slugs} key={`announcements-${position}-${slugs.join(',')}`} position={(myPosition + position) % 4}/>)
        /* eslint-ebable react/no-array-index-key */
      })}
      <AnnouncementPicker validAnnouncements={validAnnouncements} canBid={myTurn} />
      { cont && (<ContinueButton  onclick={cont}/>) }
    </div>
  );
};

export default Announcements;
