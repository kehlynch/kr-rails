function addTrickCard(slug, trickIndex, playerPosition) {
  const compass = compassPosition(playerPosition)
  const imageFile = ['east', 'west'].includes(compass) ? `landscape_${slug}` : slug;
  const card = `<img alt="${slug}" class="kr-card trickcard" src="/assets/${imageFile}.jpg">`;
  const id = `js-trick-card-${slug}`
  getOrAddTrick(trickIndex).append(`<div class="card-container trick-card-container ${compass}" id="${id}">${card}</div>`);
}

function setWonCard(slug) {
  $(`#js-trick-card-${slug}`).find('img').addClass('won');
}

function getOrAddTrick(trickIndex) {
  const id = `js-trick-${trickIndex}`

  if ($(`#${id}`).length == 0) {
    addTrick(trickIndex, id);
  }
  return $(`#${id}`)
}

function addTrick(trickIndex, id) {
  // initialize as invisible, reveal with nextTrick button, unless 1st trick
  console.log("addTrick", trickIndex, id);
  const visibleClass = trickIndex == 0 ? '' : 'd-none';
  $("#js-tricks").prepend(`<div class="trick-container ${visibleClass}" id="${id}"></div>`)
}

function revealTrick(trickIndex) {
  console.log('revealTrick', trickIndex);
  // hide the other tricks 
  $("#js-tricks").find('.trick-container').addClass('d-none');
  // reveal the first trick (cos we prepend)
  getOrAddTrick(trickIndex).removeClass('d-none');
  setState('visible-trick', trickIndex);
  updateHandPickable();
  setInstruction('Play a card');
}

function compassPosition(pos) {
  // https://web.archive.org/web/20090717035140if_/javascript.about.com/od/problemsolving/a/modulobug.htm
  Number.prototype.mod = function(n) {
    return ((this%n)+n)%n;
  }
  const compassPoints = ['south', 'east', 'north', 'west'];
  const index = (pos - playerPosition()).mod(4);
  console.log("compassPosition", pos, playerPosition(), index, compassPoints[index]);
  return compassPoints[index]
}
