import React from "react";
import PropTypes from "prop-types";

import { createSession } from "../api";
import styles from "../styles/Login.module.scss";

class Login extends React.Component {
  constructor(props) {
    super(props);
    this.state = { playerName: "" };

    this.handleNameChange = this.handleNameChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  handleSubmit(event) {
    const { setPlayer } = this.props;
    const { playerName } = this.state;

    createSession({ name: playerName }, setPlayer);
    event.preventDefault();
  }

  handleNameChange(event) {
    this.setState({ playerName: event.target.value });
  }

  render() {
    const { playerName } = this.state;
    return (
      <div className={styles.container}>
        <h1 className="display-4">Welcome Player!</h1>
        <p className="lead">What’s your name?</p>
        <hr className="my-4" />

        <form onSubmit={this.handleSubmit}>
          <label htmlFor="PlayerName">
            <input
              type="text"
              value={playerName}
              onChange={this.handleNameChange}
              id="playerName"
            />
          </label>
          <input type="submit" value="Play some Königsrufen" />
        </form>
      </div>
    );
  }
}

Login.propTypes = {
  setPlayer: PropTypes.func.isRequired,
};

export default Login;
