$('.addFolder').live 'click',(event) =>
  $(".modal#new_folder").find('form')[0].reset()  
  $(".modal#new_folder").modal('show')  
  
$('.close-modal').live 'click',(event) =>
  $(".modal").modal('hide')  

