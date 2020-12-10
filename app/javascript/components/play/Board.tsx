import React from "react";

import Players from "./Players";
import styles from "../../styles/play/Board.module.scss";

export type BoardProps = {
  game: GameType | undefined,
  player: PlayerType | undefined
}


const Board = ({ player, game }: BoardProps): React.ReactElement => {
  if (game === undefined || player === undefined) {
    return <div>loading...</div>
  }
  return (
    <div className={styles.container}>
      <div>Welcome to game {game.id}</div>
      <Players players={game.players} player={player} />
    </div>
  );
};

export default Board;
