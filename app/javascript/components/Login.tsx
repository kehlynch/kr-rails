import React, { useState } from "react";
import { Redirect } from "react-router-dom";

import NavBar from "./NavBar";
import { createSession } from "../api";
import styles from "../styles/Login.module.scss";

const Login = (): React.ReactElement => {
  const [ player, setPlayer ] = useState();
  const [ playerName, setPlayerName ] = useState("");

  const handleSubmit = (event: any): void => {
    createSession(playerName, setPlayer);
    event.preventDefault();
  }

  const handleNameChange = (event: any): void => {
    setPlayerName(event.target.value);
  }

  if (player) {
    return <Redirect to="/" />
  }

  return (
    <>
      <NavBar/>
    <div className={styles.container}>
      <div className={styles.innerContainer}>
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
    </div>
    </>
  );
}

export default Login;
