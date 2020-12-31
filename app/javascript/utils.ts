import {
  AnnouncementSlug,
  WinningBidSlug,
  BidSlug,
  Stage,
  StageNumber,
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

export const getStageNumber = (stage: Stage): StageNumber => {
  return {
    [Stage.Bid]: StageNumber.Bid,
    [Stage.King]: StageNumber.King,
    [Stage.PickTalon]: StageNumber.PickTalon,
    [Stage.ResolveTalon]: StageNumber.ResolveTalon,
    [Stage.Announcement]: StageNumber.Announcement,
    [Stage.Trick]: StageNumber.Trick,
    [Stage.Finished]: StageNumber.Finished,
  }[stage];
};
