function toggleAnnouncement(slug) {
  console.log("toggleAnnouncement", slug);
  const checkbox = $(`#valid-announcement-${slug}`)
  console.log("toggleAnouncement", checkbox);
  if (slug == 'pass') {
    $('#js-valid-announcements').find('input').each((i, checkbox) => {
      $(checkbox).prop('checked', false)
      // checkbox.nextElementSibling.classList.toggle('active');
      $(checkbox).next().removeClass('active');
    })

    // document.querySelectorAll('input[type="checkbox"]:checked').forEach((checkbox) => {
    //   checkbox.checked = false;
    //   checkbox.nextElementSibling.classList.toggle('active');
    // })
  } else {
    const passCheckbox = $('#valid-announcement-pass');
    passCheckbox.prop('checked', false);
    passCheckbox.next().removeClass('active');
  }

  checkbox.prop('checked', !checkbox[0].checked);
  checkbox.next().toggleClass('active');

  var selected = $('#js-valid-announcements').find('input[type="checkbox"]:checked').length
  console.log('selected', selected);
  const birdBidNeeded = wonBid() == 'besser_rufer' && activeBirdBids() == 0;
  const disabled = selected == 0 || birdBidNeeded;
  console.log("disabled", disabled);
  $('#js-announcements-submit').prop('disabled', disabled);
}

function activeBirdBids() {
  const birds = ["pagat", "uhu", "kakadu"]
  const selected = Array.from(document.querySelectorAll('input[type="checkbox"]:checked')).filter((checkbox) => birds.includes(checkbox.value));
  return selected.length
}

const ANNOUNCEMENT_NAMES = {
  'pass': 'Pass',
  'pagat': 'Pagat',
  'uhu': 'Uhu',
  'kakadu': 'Kakadu',
  'king': 'King Ultimo',
  'forty_five': '45',
  'valat': 'Valat'
}

function addAnnouncement(slug, player) {
  const name = ANNOUNCEMENT_NAMES[slug]
  $(`#js-player-${player}-announcements`).append(`<h6 class="card-subtitle mb-2 text-muted">${name}</h6>`)

}

function addValidAnnouncement(slug) {
  const name = ANNOUNCEMENT_NAMES[slug];
  const input = `<input hidden=true id="valid-announcement-${slug}" name="game[make_announcement][]" type="checkbox" value="${slug}" />`

  const button = `<button name="button" type="button" alt="${name}" class="announcement-button btn btn-outline-dark" onclick="toggleAnnouncement('${slug}')">${name}</button>`
  $(`#js-valid-announcement-buttons`).append(input)
  $(`#js-valid-announcement-buttons`).append(button)

}

function addValidAnnouncements(slugs) {
  slugs.forEach(addValidAnnouncement)
  $("#js-valid-announcements").removeClass("d-none");
}

function submitAnnouncement(announcementSlug) {
  submitGame(announcementSlug);
  $("#js-valid-announcements").addClass("d-none");
}
