$(document).ready(function(){
  $('#skill-search').hsearchbox({
    url: '/skill_users',
    param: 'search',
    dom_id: '#result-skill-search'
  });
});
