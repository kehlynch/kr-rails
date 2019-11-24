function cardImagePath(slug, landscape) {
  return landscape ? `/assets/images/${slug}_landscape.jpg` : `/assets/images/${slug}.jpg`;
}

function playCard(checkboxId) {
  submitGame(checkboxId);
  $(checkboxId).parent().remove();
  makeHandUnpickable();
}
