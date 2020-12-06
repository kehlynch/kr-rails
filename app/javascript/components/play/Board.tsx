import React from "react";

import Players from "./Players";
import { GameType, PlayerType } from "../../types";

export type BoardProps = {
  game: GameType | undefined,
  player: PlayerType | undefined
}


const Board = ({ player, game }: BoardProps): React.ReactElement => {
  if (game === undefined || player === undefined) {
    return <div>loading...</div>
  }
  return (
    <div>
      <div>Welcome to game {game.id}</div>
      <Players players={game.players} player={player} />
    </div>
  );
};

export default Board;
