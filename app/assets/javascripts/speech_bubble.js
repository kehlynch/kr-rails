function addSpeech(playerPosition, message) {
  console.log("addSpeech", playerPosition, message);
  const messageDiv = `<div>${message}</div>`;
  $(`#js-speech-bubble-${playerPosition}`).append(messageDiv);
}

function clearSpeech(playerPosition) {
  $(`#js-speech-bubble-${playerPosition}`).empty();
}

function clearAllSpeech() {
  [0, 1, 2, 3].forEach(clearSpeech);
}
