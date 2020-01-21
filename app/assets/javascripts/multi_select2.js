/**
 * A setup function to make select2 jquery plugin play as an ordinary form when
 * using the "multiple" flag.
 *
 * Also allows options to be disabled.
 *
 *
 * @param {String} selector - CSS selector pointing to a <select /> element
 * @param {Object} options
 * @param {Array<String>} options.value - initial value
 * @param {Array<String>} options.disabledOptions - disabled option values to disable
 * @param {Array<String>} options.noMatchesFormat - i18n'd string to show when no matches found when filtering
 */
window.initializeSelect2 = function(selector, options) {
  var $select = $(selector);

  var optionsToDisableSelector = (options.disabledOptions || []).map(function (optionId) {
    return "option[value=" + optionId + "]";
  }).join(',');

  var $options = $select.find(optionsToDisableSelector);
  $options.attr('disabled', 'disabled');

  $select.select2({
    formatNoMatches: function () {
      return options.noMatchesFormat
    }
  });

  $select.val(options.value.length === 0 ? null : options.value);
  $select.trigger('change');
}
