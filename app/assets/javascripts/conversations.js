(function() {
  $(document).on('click', '.toggle-window', function(e) {
    e.preventDefault();
    var panel = $(this).closest('.box-message');
    var messages_list = panel.find('.messages-list');

    panel.find('.panel-body').toggle("fast",function(){
      panel.find('.box-message-body').css('min-height', '0px')
    });

    if (panel.find('.panel-body').is(':visible')) {
      var height = messages_list[0].scrollHeight;
      messages_list.scrollTop(height);
    }
  });
})();
