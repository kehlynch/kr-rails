function updateFinished(newData, oldData) {
  console.log("updateFinished");
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
      <th scope="row">${name}</th>
      <td>${won_tricks_count}</td>
      <td>${points}</td>
      <td>${team_points}</td>
      <td>${game_points}</td>
      <td class="${winner && 'score-winner'}"></td>
  `
  $(`#${id}`).empty().append(html);
}


function updatePoints({ games }) {
  games.forEach(updateGamePoints);
}

function updateGamePoints({ players, shorthands }) {
  players.forEach(updatePlayerGamePoints);
  updateShorthands(shorthands);
}

function updatePlayerGamePoints({ id, points, forehand, declarer, winner }) {
  const html = `<div class="game-point-inner">${points}</div>`
  const node = $(`#${id}`);
  node.empty().append(html);
  node.toggleClass('forehand', forehand);
  node.toggleClass('declarer', declarer);
  node.toggleClass('winner', winner);
}

function updateShorthands({ id, bid, announcements }) {
  const bidHtml = bidShorthand(bid);
  const announcementsHtml = announcements.map(announcementShorthand).join(' ');
  $(`#${id}`).empty().append(bidHtml + announcementsHtml);
}

function bidShorthand({ shorthand, classes }) {
  return `<span class="bid-shorthand ${classes}">${shorthand}</span>`
}

function announcementShorthand({ shorthand, classes }) {
  return `<span class="announcement-shorthand ${classes}">${shorthand}</span>`
}

function updateGameAnnouncementsShorthands(announcements) {
  announcements.forEach(({ id, shorthand, classes }) => {

  })
}


function kontraClass(kontra) {
  return { 2: 'kontra', 4: 'rekontra', 8: 'subkontra' }[kontra];
}

function showScores() {
  hideStage(stages.PICK_TALON);
  hide(sections.POINTS);
  reveal(sections.SCORES);
}

function showPoints() {
  hideStage(stages.PICK_TALON);
  hide(sections.SCORES);
  reveal(sections.POINTS);
}

function showTalonGameEnd() {
  hide(sections.SCORES);
  hide(sections.POINTS);
  revealStage(stages.PICK_TALON);
}
