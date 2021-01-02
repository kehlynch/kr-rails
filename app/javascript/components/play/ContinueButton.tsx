import React from "react";

import Button from "react-bootstrap/Button";
import styles from "../../styles/play/ContinueButton.module.scss";

export type ContinueButtonProps = {
  onclick: () => void;
}

const ContinueButton = ({ onclick }: ContinueButtonProps): React.ReactElement => {
  return (
    <Button className={styles.container} variant="primary" onClick={onclick}>Continue</Button>
  );
};

export default ContinueButton;
