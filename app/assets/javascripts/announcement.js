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
  const name = announcementShortname(slug);
  $(`#js-player-${player}-announcements`).find('h6').append(name);
}

function announcementShortname(slug) {
  return ANNOUNCEMENT_SHORTNAMES[slug];
}

function announcementName(slug) {
  return ANNOUNCEMENT_NAMES[slug] || kontraName(slug);
}

function kontraName(slug) {
  const [name, kontrableSlug, id] = slug.split('-');
  const kontrableName =  ANNOUNCEMENT_NAMES[kontrableSlug] || 'game';
  return `${name} the ${kontrableName}`
}


// announcement picking buttons
function addValidAnnouncement(slug) {
  const name = announcementName(slug);
  const input = `
    <input
      hidden=true
      id="valid-announcement-${slug}"
      name="game[make_announcement]"
      type="checkbox"
      value="${slug}"
    />
  `

  const button = `
    <button
      name="button"
      type="button"
      alt="${name}"
      class="btn btn-outline-dark"
      onclick="submitBid('${slug}', 'announcement')"
    >
      ${name}
    </button>
  `
  $(`#js-valid-announcements`).append(input)
  $(`#js-valid-announcements`).append(button)
}

function addValidAnnouncements(slugs) {
  $(`#js-valid-announcements`).empty();
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
