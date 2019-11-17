function addTrickCard(slug, trickIndex, playerPosition) {
  console.log('addTrickCard', slug, playerPosition);
  const imageFile = [1, 3].includes(playerPosition) ? `landscape_${slug}` : slug;
  const card = `<img alt="${slug}" class="kr-card trickcard" src="/assets/${imageFile}.jpg">`;
  getOrAddTrick(trickIndex).append(`<div class="card-container trick-card-container position-${playerPosition}">${card}</div>`);
  if ($(`#js-trick-${trickIndex}`).find("img").length == 4) {
    // TODO alert to click for next trick
  }
}

function getOrAddTrick(trickIndex) {
  const id = `js-trick-${trickIndex}`
  // initialize as invisible, reveal with nextTrick button, unless 1st trick
  if ($(`#${id}`).length == 0) {
    addTrick(trickIndex, id);
  }
  return $(`#${id}`)
}

function addTrick(trickIndex, id) {
  const visibleClass = trickIndex == 0 ? '' : 'd-none';
  $("#js-tricks").prepend(`<div class="trick-container ${visibleClass}" id="${id}"></div>`)
}

function revealTrick(trickIndex) {
  console.log("revealTrick", trickIndex);
  // hide the other tricks 
  $("#js-tricks").find('.trick-container').addClass('d-none');
  // reveal the first trick (cos we prepend)
  getOrAddTrick(trickIndex).removeClass('d-none');
  setState('visible-trick', trickIndex);
  updateHandPickable();
}
