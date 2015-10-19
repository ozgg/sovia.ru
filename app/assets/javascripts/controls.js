// AJAX methods for controls

$(document).ready(function() {
    $('.controls > .visibility').on('click', function() {
        var element = $(this);
        var uri = element.data('uri');
        $.post(uri, function(response) {
            element.toggleClass('hidden');
        });
    });
    $('.controls > .edit').on('click', function() {
        window.location.href = $(this).data('uri');
    });
});