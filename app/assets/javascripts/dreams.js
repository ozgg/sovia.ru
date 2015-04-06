$(document).ready(function () {
    $('input[type=range]').on('change', function () {
        var span = $(this).parent().find('span');
        span.html($(this).val());
    });
});
