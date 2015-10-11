// AJAX methods for controls

$(document).ready(function() {
    $('.controls > .visibility').on('click', function() {
        var element = $(this);
        var uri = element.data('uri');
        $.post(uri, function(response) {
            element.toggleClass('hidden');
        });
    });
});