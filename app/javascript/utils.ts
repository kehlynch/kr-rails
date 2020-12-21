import { WinningBidSlug, BidSlug } from "./types";

export const bidName = (bidSlug: BidSlug): string => {
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
  }[bidSlug];
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
