function addScores(scores) {
  $('#js-score-container').find('tbody').empty();
  scores.forEach(addScore);
}

function addScore(score) {
  $('#js-score-container').find('tbody').append('<tr></tr>');
  const tr = $('#js-score-container').find('tbody').last('tr');
  tr.append(`<th scope="row">${score['name']}</th>`);
  tr.append(`<td>${score['won_tricks_count']}</td>`);
  tr.append(`<td>${score['points']}</td>`);
  tr.append(`<td>${score['team_points']}</td>`);
  tr.append(`<td>${score['game_points']}</td>`);
  tr.append(`<td class=${score['winner'] ? 'score-winner' : ''}></td>`);
}
