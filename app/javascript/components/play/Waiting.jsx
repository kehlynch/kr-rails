import React from "react";
// import PropTypes from "prop-types";
import Spinner from "react-bootstrap/Spinner";
// import { PlayerType } from "../../types";
import styles from "../../styles/play/Waiting.module.scss";

const Waiting = () => {
  return (
    <Spinner animation="grow" size="sm">
      <span className="sr-only">Loading...</span>
      <div className={styles.test} />
    </Spinner>
  );
};

Waiting.propTypes = {};

export default Waiting;
