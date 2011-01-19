function makeScrollable(wrapper, scrollable){
  // Get jQuery elements
  var wrapper = $(wrapper), scrollable = $(scrollable);

  wrapper.css({overflow: "hidden"});
  scrollable.slideDown("slow", function(){
    enable(); 
  });                 
  

  function enable(){
   
  }
}