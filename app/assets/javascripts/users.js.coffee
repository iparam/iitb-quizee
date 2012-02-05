# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$('.addUser').live 'click',(event) =>
  $(".modal").find('form')[0].reset()  
  $(".modal").modal('show')  
  
$('.close-modal').live 'click',(event) =>
  $(".modal").hide()  

$('.editUser').live 'click',(event) ->
  edit_url = $(this).attr('href')
  
  $.ajax edit_url,
    dataType: 'html'
    type: 'GET'
    success: (html) ->
       $("#editUserModal").html  html
       $("#editUserModal").modal('show')
       $("#editUserModal").find(".modal-title").text("Edit User")
       $("#editUserModal").find(".modal").show() 
     
  return false      
