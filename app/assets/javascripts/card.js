function playCard(checkboxId) {
  if (!inProgress()) {
    setInProgress(true);
    submitGame(checkboxId);
    $(checkboxId).parent().remove();
  }
}
