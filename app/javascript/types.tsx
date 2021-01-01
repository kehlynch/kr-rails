export enum Stage {
  Bid = 'bids',
  King = 'kings',
  PickTalon = 'pick_talon',
  ResolveTalon = 'resolve_talon',
  Announcement = 'announcements',
  Trick = 'tricks',
  Finished = 'finished'
}

export enum BidSlug {
  Pass = 'pass',
  Rufer = 'rufer',
  Solo = 'solo',
  Dreier = 'dreier',
  BesserRufer = 'besser_rufer',
  SoloDreier = 'solo_dreier',
  Piccolo = 'piccolo',
  Bettel = 'bettel',
  CallKing = 'call_king',
  Trischaken = 'trischaken',
  Sechserdreier = 'sechserdreier'
}

export enum AnnouncementSlug {
  Pass = 'pass',
  Pagat = 'pagat',
  Uhu = 'uhu',
  Kakadu = 'kakadu',
  King = 'king',
  FortyFive = 'forty_five',
  Valat = 'valat',
}

export type DeclarableSlug = BidSlug | AnnouncementSlug;

export enum Position {
  South = 0,
  East = 1,
  North = 2,
  West = 3
}

export type WinningBidSlug = BidSlug.Solo | BidSlug.Piccolo | BidSlug.Dreier | BidSlug.BesserRufer | BidSlug.SoloDreier | BidSlug.Bettel | BidSlug.CallKing | BidSlug.Trischaken | BidSlug.Sechserdreier

export interface MatchPlayerType {
  id: number,
  name: string,
  human: boolean,
}

export interface MatchListingType {
  id: number,
  points: number,
  daysOld: number,
  handDescription: string,
  players: Array<MatchPlayerType>,
}

export interface PlayerListingType {
  id: number,
  name: string,
  human: boolean,
  points: number,
  gameCount: number,
  matches: Array<MatchListingType>,
}

export interface CardType {
  slug: string,
}

export interface PlayerType {
  id: number,
  name: string,
}

export interface AnnouncementType {
  id: number,
  slug: AnnouncementSlug,
  playerPosition: Position
}

export interface BidType {
  id: number,
  slug: BidSlug,
  playerPosition: Position
}

export type DeclarableType = AnnouncementType | BidType;

export interface GamePlayerType {
  id: number,
  playerId: number,
  name: string,
  position: Position,
  // points: number,
  // gameCount: number,
  forehand: boolean,
  declarer: boolean,
  announcements: Array<AnnouncementType>,
  // matches: Array<MatchListingType>,
  cards: Array<CardType>,
  viewedBids: boolean,
  viewedKings: boolean,
  viewedTalon: boolean,
  viewedAnnouncements: boolean,
    viewedTrick: number | false,
}

export interface GameType {
  id: number,
  gamePlayers: Array<GamePlayerType>,
  partnerId: number,
  partnerKnown: boolean,
  nextGamePlayerId: number,
  stage: Stage,
  validBids: Array<BidSlug>,
  bids: Array<BidType>,
  validAnnouncements: Array<AnnouncementSlug>,
  announcements: Array<AnnouncementType>,
  kingRequired: boolean,
    announcementsRequired: boolean,
    talonRequired: 3 | 6 | false
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
