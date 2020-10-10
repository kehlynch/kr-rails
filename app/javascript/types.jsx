import PropTypes from "prop-types";

export const PlayerType = PropTypes.shape({
  id: PropTypes.number,
  name: PropTypes.string,
});

export const GameType = PropTypes.shape({
  id: PropTypes.number,
  name: PropTypes.string,
});
