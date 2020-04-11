function addRemark(playerPosition, message) {
  console.log("addSpeech", playerPosition, message);
  $(`#js-speech-bubble-${playerPosition}`).empty();
  $(`#js-speech-bubble-${playerPosition}`).append(message);
}
