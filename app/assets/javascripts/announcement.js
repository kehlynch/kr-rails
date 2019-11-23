const ANNOUNCEMENT_NAMES = {
  'pass': 'Pass',
  'pagat': 'Pagat',
  'uhu': 'Uhu',
  'kakadu': 'Kakadu',
  'king': 'King Ultimo',
  'forty_five': '45',
  'valat': 'Valat'
}

const ANNOUNCEMENT_SHORTNAMES = {
  'pagat': 'I',
  'uhu': 'II',
  'kakadu': 'III',
  'king': 'K',
  'forty_five': '45',
  'valat': 'V'
}

// announcement indicators under players
function addAnnouncement(slug, player) {
  console.log("addAnnouncement", slug, player);
  const name = ANNOUNCEMENT_SHORTNAMES[slug]
  if (name) {
    $(`#js-player-${player}-announcements`).find('h6').append(` ${name}`);
  }
}

// announcement picking buttons
function addValidAnnouncement(slug) {
  const name = ANNOUNCEMENT_NAMES[slug];
  const input = `<input hidden=true id="valid-announcement-${slug}" name="game[make_announcement][]" type="checkbox" value="${slug}" />`

  const button = `<button name="button" type="button" alt="${name}" class="announcement-button btn btn-outline-dark" onclick="toggleAnnouncement('${slug}')">${name}</button>`
  $(`#js-valid-announcement-buttons`).append(input)
  $(`#js-valid-announcement-buttons`).append(button)

}

function addValidAnnouncements(slugs) {
  $(`#js-valid-announcement-buttons`).empty();
  slugs.forEach(addValidAnnouncement)
  $("#js-valid-announcements").removeClass("d-none");
}

function toggleAnnouncement(slug) {
  const checkbox = $(`#valid-announcement-${slug}`)
  if (slug == 'pass') {
    $('#js-valid-announcements').find('input').each((i, checkbox) => {
      $(checkbox).prop('checked', false)
      $(checkbox).next().removeClass('active');
    })
  } else {
    const passCheckbox = $('#valid-announcement-pass');
    passCheckbox.prop('checked', false);
    passCheckbox.next().removeClass('active');
  }

  checkbox.prop('checked', !checkbox[0].checked);
  checkbox.next().toggleClass('active');

  var selected = $('#js-valid-announcements').find('input[type="checkbox"]:checked').length
  const birdBidNeeded = wonBid() == 'besser_rufer' && activeBirdBids() == 0 && isDeclarer();
  const disabled = selected == 0 || birdBidNeeded;
  $('#js-announcements-submit').prop('disabled', disabled);
}

function activeBirdBids() {
  const birds = ["pagat", "uhu", "kakadu"]
  const selected = Array.from(document.querySelectorAll('input[type="checkbox"]:checked')).filter((checkbox) => birds.includes(checkbox.value));
  return selected.length
}

function submitAnnouncement(announcementSlug) {
  submitGame(announcementSlug);
  $("#js-valid-announcements").addClass("d-none");
}
