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
//= require lightbox-bootstrap
//= require turbolinks
//= require_tree .

$(document).ready(function() {
    var $lightbox = $('#lightbox');

    $('[data-target="#lightbox"]').on('click', function(event) {
        var $img = $(this).find('img'),
            src = $img.attr('src'),
            alt = $img.attr('alt'),
            css = {
                'maxWidth': $(window).width() - 100,
                'maxHeight': $(window).height() - 100
            };

        $lightbox.find('.close').addClass('hidden');
        $lightbox.find('img').attr('src', src);
        $lightbox.find('img').attr('alt', alt);
        $lightbox.find('img').css(css);
    });

    $lightbox.on('shown.bs.modal', function(e) {
        var $img = $lightbox.find('img');

        $lightbox.find('.modal-dialog').css({
            'width': $img.width()
        });
        $lightbox.find('.close').removeClass('hidden');
    });

    //Smooth Scrolling
    // $(function() {
    // $('a[href*="#"]:not([href="#"])').click(function() {
    //   if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
    //     var target = $(this.hash);
    //     target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
    //     if (target.length) {
    //       $('html, body').animate({
    //         scrollTop: target.offset().top
    //       }, 1000);
    //       return false;
    //     }
    //   }
    // });
    // });

    //alert disappear after few seconds
    window.setTimeout(function() {
    $(".alert").fadeTo(1000, 0).slideUp(1000, function(){
        $(this).remove();
    });
    }, 5000);


    $('#new_bought_detail').formValidation({
        fields: {
            ccNumber: {
                // The credit card number field can be retrieved
                // by [data-stripe="number"] attribute
                selector: '[data-stripe="number"]',
                validators: {
                    notEmpty: {
                        ...
                    },
                    creditCard: {
                        ...
                    }
                }
            },
            expMonth: {
                selector: '[data-stripe="exp-month"]',
                row: '.col-xs-3',
                validators: {
                    notEmpty: {
                        ...
                    },
                    digits: {
                        ...
                    },
                    callback: {
                        ...
                    }
                }
            },
            expYear: {
                selector: '[data-stripe="exp-year"]',
                row: '.col-xs-3',
                validators: {
                    notEmpty: {
                        ...
                    },
                    digits: {
                        ...
                    },
                    callback: {
                        ...
                    }
                }
            },
            cvvNumber: {
                selector: '[data-stripe="cvc"]',
                validators: {
                    notEmpty: {
                        ...
                    },
                    cvv: {
                        ...
                        creditCardField: 'ccNumber'
                    }
                }
            }
        }
    });
});
