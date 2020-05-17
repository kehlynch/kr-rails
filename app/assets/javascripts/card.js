function cardImagePath(slug, landscape) {
  return landscape ? `/assets/images/${slug}_landscape.jpg` : `/assets/images/${slug}.jpg`;
}

function playCard(checkboxId) {
  if (!inProgress()) {
    setInProgress(true);
    submitGame(checkboxId);
    $(checkboxId).parent().remove();
  }
}
