// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap-sprockets
//= require rails-timeago-all
//= require bootstrap-wysihtml5
//= require bootstrap-wysihtml5/locales
//= require locales/jquery.timeago.pl.js
//= require_tree .


//alert disappear after few seconds

$(window).load(function() {
var body = document.body;

if (body.getAttribute("data-controller") != 'bought_details' && body.getAttribute("data-action") != 'new') {
    window.setTimeout(function() {
        $(".alert").fadeTo(500, 0).slideUp(500, function() {
            $(this).remove();
        });
    }, 10000);
}
});
$(function() {
    // Nice dropdown
    $('select').material_select();
    // datepicker
    $('.datepicker').pickadate({
        selectMonths: true, // Creates a dropdown to control month
        selectYears: 120 // Creates a dropdown of 15 years to control year
    });
    //timepicker
    $('#input_starttime').pickatime({
        twelvehour: false
    });
    $('#input_endtime').pickatime({
        twelvehour: false
    });
});

$(document).ready(function() {
        // Add smooth scrolling to all links in navbar + footer link
        $(".navbar a, footer a[href='#myPage']").on('click', function(event) {
            // Make sure this.hash has a value before overriding default behavior
            if (this.hash !== "") {
                // Prevent default anchor click behavior
                event.preventDefault();

                // Store hash
                var hash = this.hash;

                // Using jQuery's animate() method to add smooth page scroll
                // The optional number (900) specifies the number of milliseconds it takes to scroll to the specified area
                $('html, body').animate({
                    scrollTop: $(hash).offset().top - 10
                }, 900, function() {

                    // Add hash (#) to URL when done scrolling (default click behavior)
                    window.location.hash = hash;
                });
            } // End if
        });

        $(window).scroll(function() {
            $(".slideanim").each(function() {
                var pos = $(this).offset().top;

                var winTop = $(window).scrollTop();
                if (pos < winTop + 600) {
                    $(this).addClass("slide");
                }
            });
        });
    })
    //carousel autoplay
$('.carousel').carousel();

//count character in forms
$('input#input_text, textarea#textarea1').characterCounter();
