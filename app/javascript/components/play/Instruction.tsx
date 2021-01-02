import React, { useEffect, useState } from "react";

import ProgressBar from 'react-bootstrap/ProgressBar';

import styles from "../../styles/play/Instruction.module.scss";

export type InstructionProps = {
  text: string,
  myTurn: boolean,
  nextPlayerName: string | undefined,
  staticText?: boolean,
  continueTime?: number,
  cont?: (() => void) | false,
}

const DEFAULT_CONTINUE_MILLISECONDS = 2000;
const INCREMENT_MILLISECONDS = 100;

const Instruction = ({ text, myTurn, nextPlayerName, staticText = false, continueTime = DEFAULT_CONTINUE_MILLISECONDS, cont = false }: InstructionProps): React.ReactElement => {

  const [milliseconds, setMilliseconds] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
     console.log('ws', continueTime, milliseconds);
      if (cont) {
        if ( milliseconds === continueTime) {
          console.log('continue');
          setMilliseconds(0);
          cont();
        } else {
          setMilliseconds(s => s + INCREMENT_MILLISECONDS);
        }
      }
    }, INCREMENT_MILLISECONDS);
    return () => clearInterval(interval);
  }, [cont, continueTime, milliseconds]);


  const displayText =
    staticText || myTurn ? text : `Waiting for ${nextPlayerName} to ${text}`;
  return (
    <div className={styles.container}>
    <div className={styles.progressBarContainer}>
     { cont && <ProgressBar variant="custom" className={styles.progressBar} max={continueTime -  3 * INCREMENT_MILLISECONDS} now={milliseconds} /> }
    </div>
    <div className={styles.textbox}>
      <p>{ displayText }</p>
    </div>
    </div>
  );
};

export default Instruction;
