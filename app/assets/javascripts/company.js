$(document).ready(function() {
  $('#tab-following').on('click', '.pagination-bar .page-link', function(e){
    var url_request;
    e.preventDefault();
    url_request = $(this).attr('href');

    $.ajax({
      dataType: 'json',
      url: url_request,
      method: 'GET',
      success: function(data) {
        $('.show-following-company').html(data.html);
        $('.pagination-bar').html(data.paginate);
      }
    });
  });
});
