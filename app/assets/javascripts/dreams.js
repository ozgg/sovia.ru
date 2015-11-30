$(document).ready(function() {
    $('.dream-place input[type=radio]').on('click', function() {
        var azimuth = $(this).data('azimuth');
        $('.dream-azimuth input[type=number]').val(azimuth);
    });
});