import {
  AnnouncementSlug,
  CardType,
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

export const sortCards = (cards: Array<CardType>): Array<CardType> => {
  return cards.sort((c1, c2) => {
    const suitOrder = ["t", "h", "s", "d", "c"];
    const suitSort = (slug: string): number => suitOrder.indexOf(slug[0]);
    const cardValue = (slug: string): number => {
      const value = parseInt(slug.split("_")[1], 10);
      return value;
    };
    const suitSort1 = suitSort(c1.slug);
    const suitSort2 = suitSort(c2.slug);
    if (suitSort1 === suitSort2) {
      return cardValue(c1.slug) > cardValue(c2.slug) ? -1 : 1;
    }
    return suitSort1 > suitSort2 ? 1 : -1;
  });
};
