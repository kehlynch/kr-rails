import ActionCable from "actioncable";

export default (playerId: number, gameId: number, setGame: Function): void => {
  const cable = ActionCable.createConsumer("/channels");

  const channelParams = {
    channel: "PlayersChannel",
    playerId,
    gameId,
  };

  cable.subscriptions.create(channelParams, setGame);
};
