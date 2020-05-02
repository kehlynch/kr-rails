function addKingMessage() {
  const message = `${declarerName()} picks ${pickedKingName()}`
  setInstruction(message);
  addMessage([message]);
}

function addMessage(message) {
  $('js-message-box').empty();
  message.forEach(addMessageLine);
  scrollMessageBox();
}

function addMessageLine(line) {
  $(`#js-message-box`).append(`<p class="card-text">${line}</p>`)
  scrollMessageBox();
}

function scrollMessageBox() {
  if ($("#js-message-box").length > 0) {
		$("#js-message-box").scrollTop($("#js-message-box")[0].scrollHeight)
	}
}

function setInstruction(inst) {
  console.log(`instruction: ${inst}`);
  clear(sections.INSTRUCTION_BOX);
  addTo(sections.INSTRUCTION_BOX, inst);

  // $('#instruction').empty();
  // $('#instruction').append(inst);
}

function setContinueInstruction() {
  setInstruction('click to continue')
}
