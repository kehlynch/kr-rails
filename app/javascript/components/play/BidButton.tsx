import React from "react";
import Button from "react-bootstrap/Button";

import { makeBid } from "../../api";
import { BidSlug } from "../../types";
import styles from "../../styles/play/BidButton.module.scss";

export type BidButtonProps = {
  name: string,
  slug: BidSlug,
  canBid: boolean
}

const BidButton = ({ name, slug, canBid }: BidButtonProps): React.ReactElement => {
  const onclick = () => canBid && makeBid(slug);
  return (
    <Button variant="primary" className={styles.container} onClick={onclick}>{name}</Button>
  );
};

export default BidButton;
