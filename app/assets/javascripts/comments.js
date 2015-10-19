$(document).ready(function() {
    $('section.comments').find('div.actions > div.reply').on('click', function() {
        var parent_comment = $(this).parent().parent();
        var parent_id = parseInt(parent_comment.attr('id').replace('comment-', ''));

        $(this).parent().find('div.container').append($('#new_comment'));
        $('#comment_parent_id').val(parent_id);
    });

    $('section.reply-container').find('h1').on('click', function() {
        $(this).parent().find('div.container').append($('#new_comment'));
        $('#comment_parent_id').val('');
    });
});
