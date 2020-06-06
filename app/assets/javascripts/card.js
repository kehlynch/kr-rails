function playCard(checkboxId) {
  if (!inProgress()) {
    setInProgress(true);
    submitGame(checkboxId);
    $(checkboxId).parent().remove();
  }
}

function cardHtml(slug, classes, onclick) {
  // really ugly way to get image path from the exisitng html cos Heroku adds strings to them
  const imageSrc = $(`img[alt=${slug}]`).attr('src');
  return `<img alt="${slug}" class="kr-card ${classes}" src="${imageSrc}" onclick="${onclick}">`;
}
