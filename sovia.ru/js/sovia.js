/**
 * Created with JetBrains PhpStorm.
 * User: Maxim
 * Date: 14.07.12
 * Time: 2:05
 * To change this template use File | Settings | File Templates.
 */

function moveAnswerForm(parentId)
{
    $('#comment-footer-' + parentId).after($('#answer-form'));
    $('#answer-form').show();
    $('#answer-parent').val(parentId);
}

function replaceTagFieldSeparator(targetField)
{
    targetField.value = targetField.value.replace(/[\.;]/g, ',');
}