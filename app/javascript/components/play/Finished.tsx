import React from "react";

import DeclarableResult from "./finished/DeclarableResult";
import styles from "../../styles/play/Finished.module.scss";
import { GamePlayerType, GameType } from "../../types";


export type FinishedProps = {
  players: Array<GamePlayerType>;
  game: GameType;
}

const Finished = ({ players, game }: FinishedProps): React.ReactElement => {
  return (
    <div className={styles.container}>
      { game.outcomes.map((outcome) => <DeclarableResult key={outcome.slug} result={outcome} players={players} />) }
    </div>
  );
};

export default Finished;
