function toggleCard(checkboxId, requiredCount) {
  const checkbox = $(`#${checkboxId}`)
  const previouslyPicked = checkbox.prop('checked');
  checkbox.prop('checked', !previouslyPicked)
  const slug = checkbox.prop('value');
  const onclick = `toggleCard('${checkboxId}', ${requiredCount})`
  previouslyPicked ? removeFromPicked(slug) : addToPicked(slug, onclick);
  checkbox.next().toggleClass('picked');
  const selectedCount = $("#js-resolve-talon-hand").find('input[type="checkbox"]:checked').length;

  const submitButton = $('#talon-submit');
  if (selectedCount == requiredCount) {
    submitButton.attr('disabled', false);
    submitButton.empty().append('put down cards');
  } else {
    submitButton.attr('disabled', true);
    submitButton.empty().append(`pick ${requiredCount} cards to put down`);
  }
}

function removeFromPicked(slug) {
  $('#js-picked-putdowns').find(`img[alt=${slug}]`).remove();
}

function addToPicked(slug, onclick) {
  $('#js-picked-putdowns').append(cardHtml(slug, 'pickable', onclick));
}
