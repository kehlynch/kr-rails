import React from "react";
import Spinner from "react-bootstrap/Spinner";
import styles from "../../styles/play/Waiting.module.scss";

const Waiting = (): React.ReactElement => {
  return (
    <Spinner animation="grow" size="sm">
      <span className="sr-only">Loading...</span>
      <div className={styles.playerSpinner} />
    </Spinner>
  );
};

export default Waiting;
