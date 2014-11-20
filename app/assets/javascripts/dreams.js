$(document).ready(function() {
    $('article.entry > aside ul').toggle();
    $('article.entry > aside div').on('click', function() {
        $(this).toggleClass('pressed');
        $(this).parent().find('ul').toggle();
    });

    $('input[type=range]').on('change', function() {
        var span = $(this).parent().find('span');
        span.html($(this).val());
    });
});