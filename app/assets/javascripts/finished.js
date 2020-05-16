function updateFinished(newData, oldData) {
  const updaters = {
    'instruction': setInstruction,
    'hand': updateHand,
    'scores': updateScores,
    'points': updatePoints
  }

  Object.entries(newData).forEach ( ( [ name, newValue] ) => {
    const oldValue = oldData[name];
    if ( JSON.stringify(oldValue) != JSON.stringify(newValue)) {
      const updater = updaters[name]
      if (updater) {
        updaters[name](newValue, oldValue);
      }
    }
  })
}

function updateScores(newData, oldData) {
  newData.players.forEach ( ( newValue, index ) => {
    const oldValue = oldData.players[index];
    if ( JSON.stringify(oldValue) != JSON.stringify(newValue)) {
      updatePlayerScore(newValue)
    }
  })
}

function updatePlayerScore(playerScoreData) {
  const {
    id,
    name,
    won_tricks_count,
    points,
    team_points,
    game_points,
    winner
  } = playerScoreData;
  const html = `
      <tr>
      <th scope="row">${name}</th>
      <td>${won_tricks_count}</td>
      <td>${points}</td>
      <td>${team_points}</td>
      <td>${game_points}</td>
      <td class="${winner && 'score-winner'}"></td>
    </tr>
  `
  $(`#${id}`).empty().append(html);
}


function updatePoints({ games }) {
  games.forEach(updateGamePoints);
}

function updateGamePoints({ players, bid, announcements }) {
  players.forEach(updatePlayerGamePoints);
  updateGameBidShorthand(bid);
  announements.forEach(updatePlayerGamePoints);
  updateGameAnnouncementsShorthands(bid);
}

function updatePlayerGamePoints({ id, points, forehand, declarer, winner }) {
  const html = `<div class="game-point-inner">${points}</div>`
  const node = $(`#${id}`);
  node.empty().append(html);
  node.toggleClass('forehand', forehand);
  node.toggleClass('declarer', declarer);
  node.toggleClass('winner', winner);
}

function updateGameBidShorthand({ id, shorthand, off, vs_three, kontra }) {
  const node = $(`#${id}`);
  node.empty().append(shorthand);
  node.toggleClass('off', off);
  node.toggleClass('vs_three', vs_three);
  const kontraClassName = kontraClass(kontra);
  if (kontraClassName) {
    node.addClass(kontraClassName)
  }
}

function updateGameAnnouncementsShorthands(announcements) {

}


function kontraClass(kontra) {
  return { 2: 'kontra', 4: 'rekontra', 8: 'subkontra' }[kontra];
}

function showScores() {
  hide(sections.TALON);
  hide(sections.POINTS);
  reveal(sections.SCORES);
}

function showPoints() {
  hide(sections.TALON);
  hide(sections.SCORES);
  reveal(sections.POINTS);
}

function showTalonGameEnd() {
  hide(sections.SCORES);
  hide(sections.POINTS);
  reveal(sections.TALON);
}
