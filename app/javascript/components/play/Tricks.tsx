import React from "react";

import Trick from "./Trick";

import { TrickType, Position } from "../../types";

export type TricksProps = {
  myTurn: boolean,
  myPosition: Position,
  tricks: Array<TrickType>,
  nextPlayerName: string | undefined,
  lastViewedTrick: number,
  myPlayerId: number
}

const Tricks = ({  myTurn, myPosition, tricks, nextPlayerName, lastViewedTrick, myPlayerId }: TricksProps): React.ReactElement => {
  const visibleTrick = tricks.sort((t1, t2) => t1.index > t2.index ? 1 : -1).find((t) => t.index > lastViewedTrick );
  console.log('lastViewedTrick', lastViewedTrick);

  if (!visibleTrick) {
    return <div>something went wrong</div>
  }

  return (
    <Trick myTurn={myTurn} myPosition={myPosition} trick={visibleTrick} nextPlayerName={nextPlayerName} myPlayerId={myPlayerId} />
  );
};

export default Tricks;
