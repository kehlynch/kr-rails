import React from "react";

import styles from "../../styles/play/Instruction.module.scss";
import { Stage } from "../../types";

export type InstructionProps = {
  stage: Stage,
  myTurn: boolean,
  nextPlayerName: string | undefined,
  viewedBids: boolean
}

const getActiveInstructionText = (stage: Stage): string => {
  switch(stage) {
    case Stage.Bid:
      return 'Make a bid'
    case Stage.King:
      return 'Pick a king'
    case Stage.PickTalon:
      return 'Pick half of the talon' // TODO: sort out full talon
    case Stage.ResolveTalon:
      return 'resolve the talon'
    case Stage.Announcement:
      return 'Make an announcement'
    case Stage.Trick:
      return 'play a card'
    case Stage.Finished:
      return 'Finished!'
    default:
      return 'something went wrong!'
  }
}

const getPassiveInstructionText = (stage: Stage, nextPlayerName: string | undefined): string => {
  switch(stage) {
    case Stage.Bid:
      return `Waiting for ${nextPlayerName} to make a bid`
    case Stage.Announcement:
      return `Waiting for ${nextPlayerName} to make an announcement`
    case Stage.King:
      return `Waiting for ${nextPlayerName} to pick a king`
    case Stage.PickTalon:
      return `Waiting for ${nextPlayerName} to pick talon`
    case Stage.ResolveTalon:
      return `Waiting for ${nextPlayerName} to resolve talon`
    case Stage.Trick:
      return `Waiting for ${nextPlayerName} to play a card`
    case Stage.Finished:
      return 'Finished!'
    default:
      return 'something went wrong!'
  }
}

const getInstructionText = (stage: Stage, nextPlayerName: string | undefined, myTurn: boolean, viewedBids: boolean): string => {
  if (stage !== Stage.Bid && !viewedBids) { return "bidding finished" }
  if (myTurn) { return getActiveInstructionText(stage) }
  return getPassiveInstructionText(stage, nextPlayerName)
}

const Instruction = ({ stage, myTurn, nextPlayerName, viewedBids }: InstructionProps): React.ReactElement => {
  const instructionText = getInstructionText(stage, nextPlayerName, myTurn, viewedBids);
  return (
    <div className={styles.container}>
      { instructionText }
    </div>
  );
};

export default Instruction;
