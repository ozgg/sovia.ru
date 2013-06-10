<?php
/**
 * 
 * 
 * Date: 27.05.13
 * Time: 23:36
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 */

namespace Web\Controllers;

use Sovia\Application\Controller;

class IndexController extends Controller
{
    public function indexAction()
    {
        $this->setParameter('title', 'Главная страница');
    }
}
