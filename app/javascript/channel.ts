import ActionCable from "actioncable";

export const connectToPlayersChannel = (
  playerId: number,
  gameId: number,
  setGame: Function
): void => {
  const cable = ActionCable.createConsumer("/channels");

  const channelParams = {
    channel: "PlayersChannel",
    playerId,
    gameId,
  };

  cable.subscriptions.create(channelParams, setGame);
};

export const connectToMatchesChannel = (
  matchId: number,
  setMatch: Function
): void => {
  const cable = ActionCable.createConsumer("/channels");

  const channelParams = {
    channel: "MatchesChannel",
    id: matchId,
  };

  cable.subscriptions.create(channelParams, setMatch);
};
