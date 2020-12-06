export interface PlayerListingType {
  id: number,
  name: string,
  human: boolean,
}

export interface MatchListingType {
  id: number,
  points: number,
  daysOld: number,
  handDescription: string,
  players: Array<PlayerListingType>,
}

export interface AnnouncementType {

}

export interface PlayerType {
  id: number,
  name: string,
  points: number,
  gameCount: number,
  forehand: boolean,
  declarer: boolean,
  partner: boolean,
  nextToPlay: boolean,
  announcements: Array<AnnouncementType>,
  matches: Array<MatchListingType>
}

export interface GameType {
  id: number,
  players: Array<PlayerListingType>
}

export interface GameListingType {
  id: number,
  players: Array<PlayerListingType>
}

export interface MatchType {
  id: number,
  games: Array<GameListingType>,
  players: Array<PlayerListingType>
}
