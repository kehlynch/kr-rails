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

export const connectToGamesChannel = (
  gameId: number,
  setGame: Function
): void => {
  console.log("connecting to games channel");
  const cable = ActionCable.createConsumer("/channels");

  const channelParams = {
    channel: "GameChannel",
    id: gameId,
  };

  cable.subscriptions.create(channelParams, (data: any) => {
    console.log("channel game data", data);
    setGame(data);
  });
};

export const connectToTestChannel = (callback: Function): void => {
  console.log("connecting to test channel");
  const cable = ActionCable.createConsumer("/channels");

  // const channelParams = {
  //   channel: "TestChannel",
  // };

  cable.subscriptions.create("TestChannel", {
    received: (data: any) => {
      console.log("test game data", data);
      callback(data);
    },
  });
};
