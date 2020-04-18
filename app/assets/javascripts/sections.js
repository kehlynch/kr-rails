const sections = {
  ANNOUNCEMENT_PICKER: 'announcement_picker',
  BID_PICKER: 'bid_picker',
  POINTS_CONTAINER: 'points_container',
  PROGRESS_SPINNER: 'progress_spinner',
  SCORES_CONTAINER: 'scores_container',
  SUBMIT_TALON: 'submit_talon',
  TALON: 'talon',

}

const ids = {
  [sections.ANNOUNCEMENT_PICKER]: 'js-valid-announcements',
  [sections.BID_PICKER]: 'js-valid-bids',
  [sections.POINTS_CONTAINER]: 'js-points-container',
  [sections.PROGRESS_SPINNER]: 'js-in-progress-spinner',
  [sections.SECTIONS_CONTAINER]: 'js-sections-container',
  [sections.SUBMIT_TALON]: 'talon-submit',
  [sections.TALON]: 'js-talon',
}

function hide(section) {
  $(`#${getId(section)}`).addClass('d-none');
}

function reveal(section) {
  $(`#${getId(section)}`).removeClass('d-none');
}

function toggle(section, state) {
  $(`#${getId(section)}`).toggleClass('d-none', state);
}

function getId(section) {
  const id = ids[section];
  if (!id) { throw new Error(`id not known for section ${section}`) }

  return id;
}
