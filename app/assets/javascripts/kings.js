function hideKings() {
  $("#js-kings").addClass("d-none");
}

function revealKings() {
  $("#js-kings").removeClass("d-none");
}

function setPickedKing(slug) {
  setKingIndicator(slug);
  setKingPickerBorder(slug);
}

function setKingIndicator(slug) {
  $("#js-king").append(`<img alt="diamond_8" class="kr-card " src="/assets/${slug}.jpg">`);
}

function setKingPickerBorder(slug) {
  $(`#pick_king_${slug}`).next().addClass('selected');
}
