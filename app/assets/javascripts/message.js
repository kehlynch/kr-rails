//= require jquery3
function addMessage(message) {
  $('js-message-box').empty();
  message.forEach(addMessageLine);
  scrollMessageBox();
}

function addMessageLine(line) {
  $(`#js-message-box`).append(`<p class="card-text">${line}</p>`)
}

function scrollMessageBox() {
	
  if ($("#js-message-box").length > 0) {
		console.log("here");
		console.log($("#js-message-box"));
		$("#js-message-box").scrollTop($("#js-message-box")[0].scrollHeight)
	}
}
