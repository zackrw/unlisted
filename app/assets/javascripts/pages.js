// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//

$(function() {

  var searchBox = $('.search-box');
  var filter = $('.filter');
  var pagePreview = $('.page-preview');

  /*
   * Search functionality.
   */
  searchBox.keyup(function(e) {
    var searchText = searchBox.val().toLowerCase();
    var matchFields = ['name', 'phone', 'slogan', 'status', 'location',
                       'city', 'country', 'category'];
    pagePreview.each(function(index, pagePreviewEl) {
      var i, fieldValue;
      for (i = 0; i < matchFields.length; i++) {
        fieldValue = $(pagePreviewEl).attr('data-' + matchFields[i]).
                                      toLowerCase();
        if (fieldValue.indexOf(searchText) !== -1) {
          $(pagePreviewEl).show();
          return;
        }
        $(pagePreviewEl).hide();
      }
    });
  });

  /*
   * Filtering by category.
   */
  filter.click(function(e) {
    if (!$(this).hasClass('selected')) {
      filter.removeClass('selected');
      $(this).addClass('selected');
      filterPages($(this).attr('data-category'));
    }
  });

  function filterPages(category) {
    pagePreview.each(function(index, pagePreviewEl) {
      if ($(pagePreviewEl).attr('data-category') !== category) {
        $(pagePreviewEl).hide();
      }
      else {
        $(pagePreviewEl).show();
      }
    });

  }

});
