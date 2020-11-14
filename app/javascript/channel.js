import ActionCable from "actioncable";

export default (playerId, gameId, setGame) => {
  console.log("creating consumer");
  const cable = ActionCable.createConsumer("/channels");

  const channelParams = {
    channel: "PlayersChannel",
    playerId,
    gameId,
  };

  cable.subscriptions.create(channelParams, setGame);
};
