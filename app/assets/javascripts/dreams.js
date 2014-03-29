$(document).ready(function() {
    $('article.entry > aside ul').toggle();
    $('article.entry > aside div').on('click', function() {
        $(this).toggleClass('pressed');
        $(this).parent().find('ul').toggle();
    });
});