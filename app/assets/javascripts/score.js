function addScores(scores) {
  scores.forEach(addScore);
}

function addScore(score) {
  $('#js-score-container').find('tbody').empty();
  $('#js-score-container').append('<tr></tr>');
  const tr = $('#js-score-container').find('tr');
  tr.append(`<th scope="row">${score.name}</th>`);
  tr.append(`<td>${player.won_tricks_count}</td>`);
  tr.append(`<td>${player.points}</td>`);
  tr.append(`<td>${player.team_points}</td>`);
  tr.append(`<td>${player.game_points}</td>`);
  tr.append(`<td class=${player.winner ? 'winner' : ''></td>`);
}
