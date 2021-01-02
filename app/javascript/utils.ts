import {
  AnnouncementSlug,
  CompassName,
  WinningBidSlug,
  BidSlug,
  Position,
} from "./types";

export const bidName = (slug: BidSlug | AnnouncementSlug): string => {
  return {
    [BidSlug.Pass]: "Pass",
    [BidSlug.Rufer]: "Rufer",
    [BidSlug.Solo]: "Solo",
    [BidSlug.Piccolo]: "Piccolo",
    [BidSlug.BesserRufer]: "Besser Rufer",
    [BidSlug.Dreier]: "Dreier",
    [BidSlug.Bettel]: "Bettel",
    [BidSlug.SoloDreier]: "Solo Dreier",
    [BidSlug.CallKing]: "Call King",
    [BidSlug.Trischaken]: "Trischaken",
    [BidSlug.Sechserdreier]: "Sechserdreier",
    [AnnouncementSlug.Pagat]: "Pagat",
    [AnnouncementSlug.Uhu]: "Uhu",
    [AnnouncementSlug.Kakadu]: "Kakadu",
    [AnnouncementSlug.King]: "King",
    [AnnouncementSlug.FortyFive]: "45",
    [AnnouncementSlug.Valat]: "Valat",
  }[slug];
};

export const bidShortName = (bidSlug: WinningBidSlug): string => {
  return {
    [BidSlug.Solo]: "S",
    [BidSlug.Piccolo]: "P",
    [BidSlug.BesserRufer]: "BR",
    [BidSlug.Dreier]: "D",
    [BidSlug.Bettel]: "B",
    [BidSlug.SoloDreier]: "SD",
    [BidSlug.CallKing]: "R",
    [BidSlug.Trischaken]: "T",
    [BidSlug.Sechserdreier]: "XI",
  }[bidSlug];
};

const mod = (n: number, m: number): number => {
  return ((n % m) + m) % m;
};

export const compassName = (
  position: Position,
  myPosition: Position
): CompassName => {
  return [
    CompassName.South,
    CompassName.East,
    CompassName.North,
    CompassName.West,
  ][mod(position - myPosition, 4)];
};
