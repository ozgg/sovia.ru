$(function() {
    $(document).on('change', 'input[type=file]', function() {
        if ($(this).data('image')) {
            var target = $('#' + $(this).data('image')).find('img');
            var input  = this;

            if (input.files && input.files[0]) {
                var reader = new FileReader();

                reader.onload = function (e) {
                    target.attr('src', e.target.result);
                };

                reader.readAsDataURL(input.files[0]);
            }
        }
    });
});
