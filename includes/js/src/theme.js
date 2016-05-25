$(document).ready(function(){
	$('header').affix({
		offset:{
			top: function (){
				return ( this.top = $( 'header' ).outerHeight( true ) );
			},
		}
	});
	
	if ( $( ".navbar-spy" ).length ) {
		// Add scrollspy to <body>
		$('body').scrollspy({
			target: '#cb-nav-collapse', 
			
		});
	
		// Add smooth scrolling to all links inside a navbar
		$("#cb-nav-collapse a").on('click', function(event){
		
		  // Make sure this.hash has a value before overriding default behavior
		  if (this.hash !== "") {
		
		    // Prevent default anchor click behavior
		    event.preventDefault();
		
		    // Store hash (#)
		    var hash = this.hash;
		
		    // Using jQuery's animate() method to add smooth page scroll
		    // The optional number (800) specifies the number of milliseconds it takes to scroll to the specified area (the speed of the animation)
		    $('html, body').animate({
		      scrollTop: $(hash).offset().top
		    }, 800, function(){
		
		      // Add hash (#) to URL when done scrolling (default click behavior)
		      window.location.hash = hash;
		    }); 
		  }// End if statement
		}); 
	}
});