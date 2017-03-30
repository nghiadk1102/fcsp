$(document).ready(function(){
  var idItems = [];

  $('.search_users').on('keyup', '#user_search', 
    function() {
      var user_search = $('#user_search').val();
      var user_ids = idItems
      data = {user_search, user_ids}

      $.get("/education/courses/" + $('#course_id').val(), data, null, 'script');
      return false;
    }
  );

  $('.search_added_users').on('keyup', '#search_added_users', 
    function() {
      $.get("/education/courses/" + $('#course_id').val(),
      $('#search_added_users').serialize(), null, 'script');
      return false;
    }
  );
 
  check_user_course = function(obj) { 
    if($(obj).is(':checked')){
      idItems.push(parseInt($(obj).val()));

    }
    else{
      var index = idItems.indexOf($(obj).val());
      idItems.splice(index, 1);
    }
  };

  $('.check_all').click( function() {
    $('input[name="users[]"]').prop('checked', this.checked)
  })

  $('.add_course_member_modal #object-member-modal').on('hidden.bs.modal', function () {
    window.location.replace("/education/courses/" + $('#course_id').val());
  })
});