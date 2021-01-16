import React, { useEffect, useState } from "react";

import ProgressBar from 'react-bootstrap/ProgressBar';

import styles from "../../styles/play/Instruction.module.scss";

export type InstructionProps = {
  text: string,
  myTurn?: boolean,
  nextPlayerName?: string | undefined,
  staticText?: boolean,
  continueTime?: number,
  cont?: (() => void) | false,
}

const DEFAULT_CONTINUE_MILLISECONDS = 2000;
const INCREMENT_MILLISECONDS = 500;

const Instruction = ({ text, myTurn = false, nextPlayerName = undefined, staticText = false, continueTime = DEFAULT_CONTINUE_MILLISECONDS, cont = false }: InstructionProps): React.ReactElement => {

  const [milliseconds, setMilliseconds] = useState(0);

  useEffect(() => {
    console.log('setting interval')
    const interval = setInterval(() => {
      console.log('interval')
      if (cont) {
        setMilliseconds(s => s + INCREMENT_MILLISECONDS);
      }
    }, INCREMENT_MILLISECONDS);
    return () => clearInterval(interval);
  }, [cont, continueTime]);

  useEffect(() => {
    console.log('settingtimeout')
    const timeout = setTimeout(() => {
      console.log('timeout')
      if (cont) {
          cont();
      }
    }, continueTime);
    return () => clearTimeout(timeout);
  }, [cont, continueTime]);


  const displayText =
    staticText || myTurn ? text : `Waiting for ${nextPlayerName} to ${text}`;
  return (
    <div className={styles.container}>
    <div className={styles.progressBarContainer}>
      { cont && <ProgressBar variant="custom" className={styles.progressBar} max={continueTime - INCREMENT_MILLISECONDS} now={milliseconds} /> }
    </div>
    <div className={styles.textbox}>
      <p>{ displayText }</p>
    </div>
    </div>
  );
};

export default Instruction;
