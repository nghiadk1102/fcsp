$(document).ready(function(){
  var idItems = [];
  var position = [];

  $('select[name="position"]').hide();

  $('#project_member_search').on('keyup',function() {

    $('input:checkbox[name="users[]"]:checked').each(function(){
      var i = $(this).val();
      position[i] = $('#project-member-position-'+i).val();
    });

    var user_search = $(this).val();
    var user_ids = idItems;
    var member_position = position;
    var data = {user_search: user_search, user_ids: user_ids,
      member_position: member_position};
    $.get('/education/projects/' + $('#project_id').val(), data, null, 'script');
    return false;
  }
  );

  $('.add_project_member_modal #object-member-modal').on('hidden.bs.modal', function () {
    window.location.replace('/education/projects/' + $('#project_id').val());
  });

  $('#search_added_members').on('keyup', function() {
    $.get('/education/projects/' + $('#project_id').val(),
    $(this).serialize(), null, 'script');
    return false;
  });
  var check_user, choose_member_position;
  check_user = function(obj) {
    if($(obj).is(':checked')){
      var i = parseInt($(obj).val());
      idItems.push(i);
      $('#project-member-position-'+i).show();
    }
    else{
      var index = idItems.indexOf(parseInt($(obj).val()));
      $('#project-member-position-'+$(obj).val()).hide();
      idItems.splice(index, 1);
    }
  };

  $(document).on('click', '.check-user', function() {
    check_user(this);
  });

  choose_member_position = function(obj) {
    var i = parseInt($(obj).parent().find('.user-add').val());
    position[i] = $(obj).val();
  };

  $(document).on('change', '.choose-member-position', function() {
    choose_member_position(this);
  });

  $('.check_all').click( function() {
    $('input[name="users[]"]').prop('checked', this.checked);
    if($(this).is(':checked')) {
      $('select[name="position"]').show();
    }
    else {
      $('select[name="position"]').hide();
    }
  });

  $('#btn-project-member').on('click', function(){
    var users = {};
    for (var i = 0; i < idItems.length; i++){
      users[idItems[i]] = position[idItems[i]];
    }
    var project_id = $('#project_id').val();
    $.ajax({
      type: 'post',
      url: '/education/project_members',
      data: {users: users, project_id: project_id},
      success: function(){
        idItems = [];
        position = [];
        users = {};
      },
      error: function(error) {
        $.growl.error({message: error});
        location.reload();
      }
    });
  });
});
