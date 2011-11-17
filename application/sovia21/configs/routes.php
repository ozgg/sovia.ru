<?php
return array(
    'home' => new Zend_Controller_Router_Route_Static(
        '/'
    ),

/*
    'sitemap' => new Zend_Controller_Router_Route_Static(
        'sitemap',
        array(
            'controller' => 'index',
            'action' => 'sitemap',
        )
    ),

    'blog_read' => new Zend_Controller_Router_Route_Static(
        'blog/read'
    ),
    'blog_entry' => new Zend_Controller_Router_Route_Regex(
        'blog/read/(\d+)-([a-z0-9][-a-z0-9.]+)',
        array(
            'controller' => 'blog',
            'action' => 'entry',
        ),
        array(
            1 => 'id',
            2 => 'alias',
        ),
        'blog/read/%d-%s'
    ),
    'blog_edit' => new Zend_Controller_Router_Route_Static(
        'blog/edit'
    ),
    'blog_edit_entry' => new Zend_Controller_Router_Route(
        'blog/edit/id/:id',
        array(
            'controller' => 'blog',
            'action' => 'edit',
        ),
        array(
            'id' => '\d+',
        )
    ),
    'blog_feed' => new Zend_Controller_Router_Route_Static(
        'rss',
        array(
            'controller' => 'blog',
            'action'     => 'rss',
        )
    ),
    'blog_archive' => new Zend_Controller_Router_Route_Static(
        'blog/archive'
    ),
    'blog_archive_year' => new Zend_Controller_Router_Route(
        'blog/archive/:year',
        array(
            'controller' => 'blog',
            'action' => 'archive',
        ),
        array(
            'year' => '\d{4}',
        )
    ),
    'blog_archive_month' => new Zend_Controller_Router_Route(
        'blog/archive/:year/:month',
        array(
            'controller' => 'blog',
            'action' => 'archive',
        ),
        array(
            'year' => '\d{4}',
            'month' => '([1-9]|1[0-2])',
        )
    ),

    'user_login' => new Zend_Controller_Router_Route_Static(
        'login',
        array(
            'controller' => 'user',
            'action'     => 'login',
        )
    ),
    'user_logout' => new Zend_Controller_Router_Route_Static(
        'logout',
        array(
            'controller' => 'user',
            'action'     => 'logout',
        )
    ),
    'user_forgot' => new Zend_Controller_Router_Route_Static(
        'user/forgot'
    ),
    'user_reset' => new Zend_Controller_Router_Route_Static(
        'user/reset'
    ),

    'series_home' => new Zend_Controller_Router_Route_Static(
        'photography/series'
    ),
    'series' => new Zend_Controller_Router_Route(
        '/photography/series/:name',
        array(
            'controller' => 'photography',
            'action' => 'series',
        ),
        array(
             'name' => '[-a-z0-9]+',
        )
    ),
    'sample_home' => new Zend_Controller_Router_Route_Static(
        'photography/sample'
    ),
    'sample' => new Zend_Controller_Router_Route(
        '/photography/sample/:name',
        array(
            'controller' => 'photography',
            'action' => 'sample',
        ),
        array(
             'name' => '[-a-z0-9]+',
        )
    ),

    'about' => new Zend_Controller_Router_Route_Static(
        'about'
    ),
//*/
);