function hideKings() {
  hide(sections.KINGS);
}

function revealKings() {
  reveal(sections.KINGS);
}

function setPickedKing(slug) {
  console.log("setPickedKing", slug);
  setKingIndicator(slug);
  setKingPickerBorder(slug);
  setState('picked-king-slug', slug);
}

function setKingIndicator(slug) {
  $("#js-king").append(`<img alt="diamond_8" class="kr-card " src="/assets/${slug}.jpg">`);
}

function setKingPickerBorder(slug) {
  $(`#pick_king_${slug}`).next().addClass('selected');
}

function pickedKingName() {
  const slug =  pickedKingSlug();
  console.log("pickedKingName slug", slug);
  return kingName(pickedKingSlug());
}

function kingName(slug) {
  if (!slug) { return }

  console.log("kingName slug", slug);

  String.prototype.titleCase = function() {
    return this.charAt(0).toUpperCase() + this.slice(1);
  }
  return`King of ${slug.split('_')[0].titleCase()}s`
}

function setKingsPickable(pickable=true) {
  if (pickable) {
    sectionElement(sections.KINGS).find('img').addClass('pickable');
  } else {
    sectionElement(sections.KINGS).find('img').removeClass('pickable');
  }
}

