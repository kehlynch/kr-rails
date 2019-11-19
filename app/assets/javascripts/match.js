function addGameSummaries(summaries) {
  $('#js-points-container').find('#js-points').empty();
  summaries.forEach(addGameSummary);
}

function addGameSummary(summary) {
  summary.players.forEach(addPlayerPoints);
  $('#js-points').append(`<div class="game-shorthands"></div>`)
  $('#js-points').children().last().append(bidShorthand(summary))
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

function bidShorthand(summary) {
  const vs_three_cls = summary.vs_three ? 'vs-three' : ''
  const off_cls = summary.off ? 'off' : ''
  return `<div class="bid-shorthand ${vs_three_cls} ${off_cls}">
    ${summary.bid}
  </div>`
}

function addAnnouncementShorthand(announcement) {
  const off_cls = announcement.off ? 'off' : ''
  const defence_cls = announcement.defence ? 'defence' : ''
  const declarer_cls = announcement.declarer ? 'declarer' : '';
  $('#js-points').children().last().append(
    `<span class="${off_cls} ${defence_cls} ${declarer_cls}">
      ${announcement.announcement}
    </span>`
  )
}
