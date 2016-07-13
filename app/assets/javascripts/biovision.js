"use strict";

$(function () {
    $(document).on('change', 'input[type=file]', function () {
        if ($(this).data('image')) {
            var target = $('#' + $(this).data('image')).find('img');
            var input = this;

            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    target.attr('src', e.target.result);
                };

                reader.readAsDataURL(input.files[0]);
            }
        }
    });

    $(document).on('click', 'div.toggleable > span', function () {
        if (!$(this).hasClass('switch')) {
            var $flag = $(this);
            var url = $(this).parent().data('url');
            var parameter = $(this).data('flag');

            $.post({
                url: url,
                data: { parameter: parameter },
                beforeSend: function() {
                    $flag.removeClass();
                    $flag.addClass('switch');
                },
                success: function(response) {
                    $flag.removeClass();
                    if (response.hasOwnProperty('data') && response['data'].hasOwnProperty(parameter)) {
                        switch (response['data'][parameter]) {
                            case true:
                                $flag.addClass('active');
                                break;
                            case false:
                                $flag.addClass('inactive');
                                break;
                            default:
                                $flag.addClass('unknown');
                        }
                    } else {
                        $flag.addClass('unknown');
                    }
                }
            }).fail(function(response) {
                $flag.removeClass();
                $flag.addClass('unknown');
                handle_ajax_failure(response);
            });
        }
    });

    $('div[data-destroy-url] button.destroy').on('click', function() {
        var $button = $(this);
        var $container = $(this).closest('div[data-destroy-url]');

        $button.attr('disabled', true);

        $.ajax($container.data('destroy-url'), {
            method: 'delete',
            success: function(response) {
                $container.remove();
            }
        }).fail(handle_ajax_failure);
    });
});

function handle_ajax_failure(response) {
    console.log(response);
}
