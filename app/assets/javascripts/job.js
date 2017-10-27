$(document).ready(function() {
  $('#job_search').on('keyup', function() {
    var job_search = $(this).val();
    var hiring_type = $('#hiring_type').val();
    var data = {job_search: job_search, hiring_type: hiring_type};
    $.get('/jobs', data, null, 'script');
  });
});
