import React from "react";

import styles from "../../styles/play/Instruction.module.scss";

export type InstructionProps = {
  text: string,
  myTurn: boolean,
  staticText: boolean,
  nextPlayerName: string | undefined,
}

const Instruction = ({ text, myTurn, nextPlayerName, staticText = false }: InstructionProps): React.ReactElement => {
  const displayText =
    staticText || myTurn ? text : `Waiting for ${nextPlayerName} to ${text}`;
  return (
    <div className={styles.container}>
      { displayText }
    </div>
  );
};

export default Instruction;
