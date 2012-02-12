$('.addDocument').live 'click',(event) =>
  $(".modal#new").find('form')[0].reset()  
  $(".modal#new").modal('show')  
  
$('.close-modal').live 'click',(event) =>
  $(".modal").modal('hide') 

