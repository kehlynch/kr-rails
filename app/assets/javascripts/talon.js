function toggleCard(checkboxId, requiredCount) {
  const checkbox = $(`#${checkboxId}`)
  checkbox.prop('checked', !checkbox.prop('checked'));
  checkbox.next().toggleClass('picked');
  const selectedCount = $("#js-resolve-talon-hand").find('input[type="checkbox"]:checked').length;
  var submitButton = document.getElementById('talon-submit')
  submitButton.disabled = selectedCount != requiredCount;
}
