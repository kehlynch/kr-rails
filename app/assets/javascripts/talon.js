function toggleCard(checkbox) {
  console.log("toggleCard", checkbox);
  checkbox.checked = !checkbox.checked;
  checkbox.nextElementSibling.classList.toggle('selected');
  var selected = $("#js-hand").find('input[type="checkbox"]:checked').length;
  var submitButton = document.getElementById('talon-submit')
  console.log(stage());
  console.log(selected);
  if (stage() == 'resolve_talon') {
    submitButton.disabled = selected != 3;
  } else if (stage() == 'resolve_whole_talon') {
    submitButton.disabled = selected != 6;
  }
}

function revealResolveTalonButton() {
  $('#talon-submit').removeClass('d-none');
}

