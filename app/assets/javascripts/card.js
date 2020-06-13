function playCard(checkboxId) {
  if (!inProgress()) {
    setInProgress(true);
    submitGame(checkboxId);
    $(checkboxId).parent().remove();
  }
}

function cardHtml(slug, classes, onclick, id, landscape) {
  const imageFile = landscape ? `landscape_${slug}` : slug;
  const imageSrc = `/assets/${imageFile}.jpg`;
  return `<img alt="${slug}" class="kr-card ${classes}" src="${imageSrc}" onclick="${onclick}" id="${id}">`;
}
