import React, { useState } from "react";

import { createSession } from "../api";
import styles from "../styles/Login.module.scss";

type LoginProps = {
  setPlayer: Function
};

const Login = (props: LoginProps): React.ReactElement => {
  const { setPlayer } = props;
  const [ playerName, setPlayerName ] = useState("");

  const handleSubmit = (event: any): void => {
    createSession(playerName, setPlayer);
    event.preventDefault();
  }

  const handleNameChange = (event: any): void => {
    setPlayerName(event.target.value);
  }

  return (
    <div className={styles.container}>
      <h1 className="display-4">Welcome Player!</h1>
      <p className="lead">What’s your name?</p>
      <hr className="my-4" />

      <form onSubmit={handleSubmit}>
        <label htmlFor="PlayerName">
          <input
            type="text"
            value={playerName}
            onChange={handleNameChange}
            id="playerName"
          />
        </label>
        <input type="submit" value="Play some Königsrufen" />
      </form>
    </div>
  );
}

export default Login;
