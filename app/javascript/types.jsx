import PropTypes from "prop-types";

export const PlayerListingType = PropTypes.shape({
  id: PropTypes.number,
  name: PropTypes.string,
  human: PropTypes.bool,
});

export const MatchListingType = PropTypes.shape({
  id: PropTypes.number,
  points: PropTypes.number,
  daysOld: PropTypes.number,
  handDescription: PropTypes.string,
  players: PropTypes.arrayOf(PlayerListingType),
});

export const PlayerType = PropTypes.shape({
  id: PropTypes.number,
  name: PropTypes.string,
  points: PropTypes.number,
  gameCount: PropTypes.number,
  matches: PropTypes.arrayOf(MatchListingType),
});

export const GameType = PropTypes.shape({
  id: PropTypes.number,
  players: PropTypes.arrayOf(PlayerListingType),
});
