import React from "react";
import PropTypes from "prop-types";
import classNames from "classnames";

import Button from "react-bootstrap/Button";
import Card from "react-bootstrap/Card";
import { gotoMatch } from "../api";
import { MatchListingType } from "../types";
import styles from "../styles/MatchListing.module.scss";

const MatchListing = ({ matchListing, joined, setGame }) => {
  console.log("setGame", setGame);
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
            onClick={() => gotoMatch(id, setGame)}
            className="stretched-link"
          >
            Go To Game
          </Button>
        )}
        {!joined && players.length < 4 && (
          <Button
            onClick={() => gotoMatch(id, setGame)}
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

MatchListing.defaultProps = {
  joined: false,
};

MatchListing.propTypes = {
  matchListing: MatchListingType,
  joined: PropTypes.bool,
  setGame: PropTypes.func,
};

export default MatchListing;
