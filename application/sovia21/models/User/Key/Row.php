<?php
/**
 * Date: 30.08.11
 * Time: 19:50
 */
 
class User_Key_Row extends Ext_Db_Table_Row
{
    public function expire()
    {
        $this->updated_at = date('Y-m-d H:i:s');
    }

    /**
     * Сгенерировать ключ
     * @return void
     */
    public function generate()
    {
        $format = '%04d-%03d-%06x-%s-%x';
        $rand = rand(0, 9999);
        $type = $this->type_id;
        $user = $this->user_id;
        $date = date('smiYHd');
        $this->body = sprintf($format, $rand, $type, $user, $date, rand(0, 16));
    }
}
