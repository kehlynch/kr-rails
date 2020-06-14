const sections = {
  BIDS: 'bids',
  KINGS: 'kings',
  PICK_TALON: 'pick_talon',
  RESOLVE_TALON: 'resolve_talon',
  ANNOUNCEMENTS: 'announcements',
  TRICKS: 'trick',
  FINISHED: 'finished',
  ANNOUNCEMENT_PICKER: 'announcement_picker',
  BID_PICKER: 'bid_picker',
  POINTS: 'points',
  SCORES: 'scores',
  PROGRESS_SPINNER: 'progress_spinner',
  SUBMIT_TALON: 'submit_talon',
  TALON: 'talon',
  FINISHED_BUTTONS: 'finished_buttons',
  INSTRUCTION_BOX: 'instruction_box',
  PLAYERS: 'players',
  BID_INSTRUCTION: 'bid_instruction',
  KINGS_INSTRUCTION: 'kings_instruction',
  RESOLVE_TALON_INSTRUCTION: 'resolve_talon_instruction'
}

const ids = {
  [sections.BIDS]: 'js-bids',
  [sections.KINGS]: 'js-kings',
  [sections.PICK_TALON]: 'js-pick-talon',
  [sections.RESOLVE_TALON]: 'js-resolve-talon',
  [sections.FINISHED]: 'js-finished',
  [sections.ANNOUNCEMENTS]: 'js-announcements',
  [sections.TRICKS]: 'js-tricks',
  [sections.FINISHED]: 'js-finished',
  [sections.ANNOUNCEMENT_PICKER]: 'js-valid-announcements',
  [sections.BID_PICKER]: 'js-bid-picker',
  [sections.FINISHED_BUTTONS]: 'js-finished-buttons',
  [sections.POINTS]: 'js-points',
  [sections.PROGRESS_SPINNER]: 'js-in-progress-spinner',
  [sections.SECTIONS_CONTAINER]: 'js-sections-container',
  [sections.SUBMIT_TALON]: 'talon-submit',
  [sections.TALON]: 'js-talon',
  [sections.INSTRUCTION_BOX]: 'instruction',
  [sections.PLAYERS]: 'js-players',
  [sections.BID_INSTRUCTION]: 'js-bid-instruction',
  [sections.KINGS_INSTRUCTION]: 'js-kings-instruction',
  [sections.RESOLVE_TALON_INSTRUCTION]: 'js-resolve_talon-instruction',
  [sections.SCORES]: 'js-scores',
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
