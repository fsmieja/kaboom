
switch_tabs (obj) ->
  $('.tab-content').hide()
  $('.tabs a').removeClass "selected"
  id = obj.attr "rel"
 
  $('#'+id).show()
  obj.addClass "selected"
  
jQuery -> 
  $('.tabs a').click ->
    switch_tabs $(this)
 
  switch_tabs $('.defaulttab')
 
 
