import React from "react";
import classNames from "classnames";

import Button from "react-bootstrap/Button";
import Card from "react-bootstrap/Card";
import { gotoMatch } from "../api";
import { MatchListingType } from "../types";
import styles from "../styles/MatchListing.module.scss";


type MatchListingProps = {
  matchListing: MatchListingType,
  joined?: boolean,
  setMatch: Function
};

const MatchListing = ({ matchListing, joined = false, setMatch }: MatchListingProps): React.ReactElement => {
  const { id, points, handDescription, daysOld, players } = matchListing;
  const daysOldDescription =
    daysOld === 0 ? "Started today" : `Started ${daysOld} days ago`;
  return (
    <Card className={styles.matchCard}>
      <Card.Body>
        <Card.Text className={styles.playerPoints}>{points}</Card.Text>
        <Card.Text className="hand-count">{handDescription}</Card.Text>
        <Card.Text className="match-days-ago">{daysOldDescription}</Card.Text>
        <Card.Text as="div">
          {players.map((p) => (
            <p
              key={`${id}-${p.id}`}
              className={classNames(styles.playerNameListing, {
                [styles.human]: p.human,
              })}
            >
              {p.name}
            </p>
          ))}
        </Card.Text>
      </Card.Body>
      <Card.Footer>
        {joined && players.length < 4 && (
          <Card.Text>Waiting for players</Card.Text>
        )}
        {joined && players.length === 4 && (
          <Button
            onClick={() => gotoMatch(id, setMatch)}
            className="stretched-link"
          >
            Go To Game
          </Button>
        )}
        {!joined && players.length < 4 && (
          <Button
            onClick={() => gotoMatch(id, setMatch)}
            className="stretched-link"
          >
            Join Game
          </Button>
        )}
        {!joined && players.length === 4 && <div>full</div>}
      </Card.Footer>
    </Card>
  );
};
export default MatchListing;
