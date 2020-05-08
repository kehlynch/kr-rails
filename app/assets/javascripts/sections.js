const sections = {
  BIDS: 'bids',
  ANNOUNCEMENTS: 'announcements',
  ANNOUNCEMENT_PICKER: 'announcement_picker',
  BID_PICKER: 'bid_picker',
  POINTS_CONTAINER: 'points_container',
  PROGRESS_SPINNER: 'progress_spinner',
  SCORES_CONTAINER: 'scores_container',
  SUBMIT_TALON: 'submit_talon',
  TALON: 'talon',
  TRICK: 'trick',
  FINISHED_BUTTONS: 'finished_buttons',
  INSTRUCTION_BOX: 'instruction_box',
  KINGS: 'kings',
  BIDS_FINISHED_MESSAGE: 'bids_finished_message',
  PLAYERS: 'players',
  BID_INSTRUCTION: 'bid_instruction',
  KINGS_INSTRUCTION: 'kings_instruction'
}

const ids = {
  [sections.ANNOUNCEMENT_PICKER]: 'js-valid-announcements',
  [sections.BID_PICKER]: 'js-bid-picker',
  [sections.FINISHED_BUTTONS]: 'js-finished-buttons',
  [sections.POINTS_CONTAINER]: 'js-points-container',
  [sections.PROGRESS_SPINNER]: 'js-in-progress-spinner',
  [sections.SECTIONS_CONTAINER]: 'js-sections-container',
  [sections.SUBMIT_TALON]: 'talon-submit',
  [sections.TALON]: 'js-talon',
  [sections.TRICK]: 'js-tricks',
  [sections.INSTRUCTION_BOX]: 'instruction',
  [sections.KINGS]: 'js-kings',
  [sections.BIDS_FINISHED_MESSAGE]: 'js-bids-finished-message',
  [sections.PLAYERS]: 'js-players',
  [sections.BID_INSTRUCTION]: 'js-bid-instruction',
  [sections.KINGS_INSTRUCTION]: 'js-kings-instruction',
  [sections.BIDS]: 'js-bids',
  [sections.ANNOUNCEMENTS]: 'js-announcements'
}

function hide(section) {
  sectionElement(section).addClass('d-none');
}

function reveal(section) {
  sectionElement(section).removeClass('d-none');
}

function toggle(section, visible) {
  sectionElement(section).toggleClass('d-none', !visible);
}

function clear(section) {
  sectionElement(section).empty()
}

function addTo(section, content) {
  sectionElement(section).append(content)
}

function sectionElement(section) {
  return $(`#${sectionId(section)}`)
}

function sectionId(section) {
  const id = ids[section];
  if (!id) { throw new Error(`id not known for section ${section}`) }

  return id;
}
