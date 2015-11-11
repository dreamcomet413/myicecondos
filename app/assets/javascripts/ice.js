/*!
 * Start Bootstrap - Creative Bootstrap Theme (http://startbootstrap.com)
 * Code licensed under the Apache License v2.0.
 * For details, see http://www.apache.org/licenses/LICENSE-2.0.
 */

(function($) {
    "use strict"; // Start of use strict

    // jQuery for page scrolling feature - requires jQuery Easing plugin
    $('a.page-scroll').bind('click', function(event) {
        var $anchor = $(this);
        $('html, body').stop().animate({
            scrollTop: ($($anchor.attr('href')).offset().top - 50)
        }, 1250, 'easeInOutExpo');
        event.preventDefault();
    });

    // Closes the Responsive Menu on Menu Item Click
    $('.navbar-collapse ul li a').click(function() {
        $('.navbar-toggle:visible').click();
    });

    // Fit Text Plugin for Main Header
    //$("h1").fitText(
    //    1.2, {
    //        minFontSize: '35px',
    //        maxFontSize: '65px'
    //    }
    //);

    // Offset for Main Navigation
    $('#mainNav').affix({
        offset: {
            top: 100
        }
    });
    
    // Scrollify

    //$.scrollify({
    //    section: "section",
    //    offset: -40
    //});

    //var paxman = new Paxman();

    //// Initialize WOW.js Scrolling Animations
    //new WOW().init();

    // Animations
    $('#fullpage').fullpage({
        'verticalCentered': false,
        'css3': true,
        //'sectionsColor': ['#F0F2F4', '#fff', '#fff', '#fff'],
        scrollOverflow: true,
        paddingTop: '40px',
        paddingBottom: '42px',
        'navigation': true,
        'navigationPosition': 'left',
        'navigationTooltips': ['Welcome', 'Cool', 'Design', 'Amenities', 'Welcome'],
        'afterLoad': function(anchorLink, index){
            if(index === 1) {
                $('section#about .building').addClass('active');
            }
        },
        'onLeave': function(index, nextIndex, direction){
            if(index === 1 && direction === 'down') {
                $('section#about .building').addClass('active');
            } else if(index === 2) {
                $('section#about .building').removeClass('active');
            } else if (index == 3 && direction == 'down'){
                $('.section').eq(index -1).removeClass('moveDown').addClass('moveUp');
            }
            else if(index == 3 && direction == 'up'){
                $('section#about .building').addClass('active');
                $('.section').eq(index -1).removeClass('moveUp').addClass('moveDown');
            }
            $('#staticImg').toggleClass('active', (index == 2 && direction == 'down' ) || (index == 4 && direction == 'up'));
            $('#staticImg').toggleClass('moveDown', nextIndex == 4);
            $('#staticImg').toggleClass('moveUp', index == 4 && direction == 'up');
        }
    });

    $('#scroll-page-top').click(function(e){
        e.preventDefault();
        $.fn.fullpage.moveTo(1);
    });

    $('#scroll-page-down').click(function(e){
        e.preventDefault();
        $.fn.fullpage.moveSectionDown();
    });

})(jQuery); // End of use strict
