import React from "react";

import styles from "../../styles/play/Outcome.module.scss";
import { DeclarableResultType } from "../../types";
import { declarableName } from "../../utils";


export type BidScoreProps = {
  result: DeclarableResultType;
}

const Outcome = ({ result}: BidScoreProps): React.ReactElement => {
const { slug, made, gamePlayers } = result;
  const bidName = declarableName(slug);

  const bidText = `${bidName} ${made ? 'made' : 'goes off'}`

  return (
    <div className={styles.container}>
      <div className={styles.bidText}>
        { bidText }
      </div>
      { gamePlayers.sort((p1, p2) => p1.points > p2.points ? 1 : -1).map(({ points, name, id}) => {
          return (
            <div key={id}>`${name} - ${points} points</div>
          )

      })}
    </div>
  );
};

export default Outcome;
