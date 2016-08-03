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
//= require jquery.turbolinks
//= require jquery_ujs
//= require jquery-ui
//= require bootstrap-sprockets
//= require rails-timeago-all
//= require bootstrap-wysihtml5
//= require bootstrap-wysihtml5/locales
//= require locales/jquery.timeago.pl.js
//= require mdb.min.js
//= require_tree .


//alert disappear after few seconds
window.setTimeout(function() {
    $(".alert").fadeTo(500, 0).slideUp(500, function() {
        $(this).remove();
    });
}, 10000);

$("#nav ul li a[href^='#']").on('click', function(e) {

    // prevent default anchor click behavior
    e.preventDefault();

    // store hash
    var hash = this.hash;

    // animate
    $('html, body').animate({
        scrollTop: $(hash).offset().top
    }, 300, function() {

        // when done, add hash to url
        // (default click behaviour)
        window.location.hash = hash;
    });

});

$(function() {
    // Nice dropdown
    $('select').material_select();
    // datepicker
    $('.datepicker').pickadate({
        selectMonths: true, // Creates a dropdown to control month
        selectYears: 15 // Creates a dropdown of 15 years to control year
    });
    //timepicker
    $('#input_starttime').pickatime({
        twelvehour: false
    });
    $('#input_endtime').pickatime({
        twelvehour: false
    });
});


//count character in forms
$('input#input_text, textarea#textarea1').characterCounter();
