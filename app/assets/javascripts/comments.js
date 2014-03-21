$(document).ready(function() {
    $('ul.comments').find('ul.actions > li > div:first-child').on('click', function() {
        var parent_comment = $(this).parent().parent().parent();
        var parent_id = parseInt(parent_comment.attr('id').replace('comment-', ''));

        $(this).parent().find('div:last-child').append($('#new_comment'));
        $('#comment_parent_id').val(parent_id);
    });

    $('div.reply-container').find('h3').on('click', function() {
        $(this).parent().find('div:last-child').append($('#new_comment'));
        $('#comment_parent_id').val('');
    });
});