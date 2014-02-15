// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
//

$(function() {

  var searchBox = $('.search-box');
  var filter = $('.filter');
  var pagePreview = $('.page-preview');
  var collageImg = $('.collage-img');

  imagesLoaded(collageImg, function() {
    collageImg.animate({
      opacity: 1
    }, 600);
  });

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
    else {
      filter.removeClass('selected');
      filterPages('all');
    }
  });

  function filterPages(category) {
    if (category === 'all') {
      pagePreview.show();
    }
    else {
      pagePreview.each(function(index, pagePreviewEl) {
        if ($(pagePreviewEl).attr('data-category') !== category) {
          $(pagePreviewEl).hide();
        }
        else {
          $(pagePreviewEl).show();
        }
      });

    }
  }

  var map = $('.map');
  var mapOptions = {
    center: new google.maps.LatLng(map.attr('data-lat'), map.attr('data-long')),
    zoom: 16
  };
  var mapEl = new google.maps.Map(map[0], mapOptions);


});
