function addGameSummaries(summaries) {
  $('#js-points-container').find('#js-points').empty();
  summaries.forEach(addGameSummary);
}

function addGameSummary(summary) {
  summary.players.forEach(addPlayerPoints);
  $('#js-points').append(`<div class="game-shorthands"></div>`)
  $('#js-points').children().last().append(bidShorthand(summary.bid))
  summary.announcements.forEach(addAnnouncementShorthand)
}

function addPlayerPoints(player) {
  const forehand_cls = player.forehand ? 'forehand' : '';
  const winner_cls = player.winner ? 'winner' : '';
  const declarer_cls = player.declarer ? 'declarer' : '';
  $('#js-points').append(`
    <div class="d-flex justify-content-center game-point ${forehand_cls} ${winner_cls} ${declarer_cls}">
      <div class="game-point-inner">
        ${player.points}
      </div>
    </div>
  `)
}

function bidShorthand(bid) {
  const vs_three_cls = bid.vs_three ? 'vs-three' : ''
  const off_cls = bid.off ? 'off' : ''
  const kontra_cls = kontraClass(bid.kontra);
  return `<div class="bid-shorthand ${vs_three_cls} ${off_cls} ${kontra_cls}">
    ${bid.shorthand}
  </div>`
}

function addAnnouncementShorthand(announcement) {
  const off_cls = announcement.off ? 'off' : '';
  const defence_cls = announcement.defence ? 'defence' : '';
  const declared_cls = announcement.declared ? 'declared' : '';
  const kontra_cls = kontraClass(announcement.kontra);
  $('#js-points').children().last().append(
    `<span class="${off_cls} ${defence_cls} ${declared_cls} ${kontra_cls}">
      ${announcement.shorthand}
    </span>`
  )
}

function kontraClass(kontra) {
  return { 2: 'kontra', 4: 'rekontra', 8: 'subkontra' }[kontra];
}
