import React from "react";
import Button from "react-bootstrap/Button";

import styles from "../../styles/play/BidButton.module.scss";

export type BidButtonProps = {
  name: string,
  onclick: (() => void),
}

const BidButton = ({ name, onclick }: BidButtonProps): React.ReactElement => {
  // const onclick = () => canBid && makeBid(slug);
  return (
    <Button variant="primary" className={styles.container} onClick={onclick}>{name}</Button>
  );
};

export default BidButton;
