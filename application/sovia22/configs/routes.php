<?php
return array(
    'home' => new Zend_Controller_Router_Route_Static(
        '/'
    ),

    'tos' => new Zend_Controller_Router_Route_Static(
        '/tos',
        array(
            'controller' => 'user',
            'action' => 'agreement',
        )
    ),
    'tos_old' => new Zend_Controller_Router_Route_Static(
        '/user/tos',
        array(
            'controller' => 'user',
            'action' => 'agreement',
            'canonical' => true,
        )
    ),

    'privacy' => new Zend_Controller_Router_Route_Static(
        '/privacy',
        array(
            'controller' => 'user',
            'action' => 'privacy',
        )
    ),
    'privacy_old' => new Zend_Controller_Router_Route_Static(
        '/user/privacy',
        array(
            'controller' => 'user',
            'action' => 'privacy',
            'canonical' => true,
        )
    ),

    'user_register' => new Zend_Controller_Router_Route_Static(
        '/register',
        array(
            'controller' => 'user',
            'action'     => 'register',
        )
    ),
    'user_login' => new Zend_Controller_Router_Route_Static(
        '/login',
        array(
            'controller' => 'user',
            'action'     => 'login',
        )
    ),
    'user_logout' => new Zend_Controller_Router_Route_Static(
        '/logout',
        array(
            'controller' => 'user',
            'action'     => 'logout',
        )
    ),
    'user_forgot' => new Zend_Controller_Router_Route_Static(
        '/user/forgot'
    ),
    'user_reset' => new Zend_Controller_Router_Route_Static(
        '/user/reset'
    ),

    'cabinet' => new Zend_Controller_Router_Route_Static(
        '/my',
        array(
            'controller' => 'cabinet',
            'action'     => '',
        )
    ),
    'cabinet_profile' => new Zend_Controller_Router_Route_Static(
        '/my/profile',
        array(
            'controller' => 'cabinet',
            'action'     => 'profile',
        )
    ),
    'cabinet_avatars' => new Zend_Controller_Router_Route_Static(
        '/my/avatars',
        array(
            'controller' => 'cabinet',
            'action'     => 'avatars',
        )
    ),
    'cabinet_dreams' => new Zend_Controller_Router_Route(
        '/my/dreams',
        array(
            'controller' => 'cabinet',
            'action'     => 'dreams',
        )
    ),
    'cabinet_symbols' => new Zend_Controller_Router_Route_Static(
        '/my/symbols',
        array(
            'controller' => 'cabinet',
            'action'     => 'symbols',
        )
    ),

    'forum' => new Zend_Controller_Router_Route_Static(
        '/forum'
    ),
    'forum_community' => new Zend_Controller_Router_Route(
        'forum/communities/:id',
        array(
            'controller' => 'forum',
            'action'     => 'community',
        )
    ),
    'forum_community_old' => new Zend_Controller_Router_Route(
        'forum/contents/of/:id',
        array(
            'controller' => 'forum',
            'action'     => 'community',
            'canonical'  => true,
        )
    ),
    'forum_entry' => new Zend_Controller_Router_Route_Regex(
        'forum/posts/(\d+)-([a-z0-9][-a-z0-9.]+)',
        array(
            'controller' => 'forum',
            'action' => 'entry',
        ),
        array(
            1 => 'id',
            2 => 'alias',
        ),
        'forum/posts/%d-%s'

    ),
    'forum_entry_old' => new Zend_Controller_Router_Route(
        'forum/read/entry/:id',
        array(
            'controller' => 'forum',
            'action'     => 'entry',
            'canonical'  => true,
        )
    ),

    'dreams' => new Zend_Controller_Router_Route_Static(
        '/dreams'
    ),
    'dreams_old' => new Zend_Controller_Router_Route_Static(
        '/dreams/read',
        array(
            'controller' => 'dreams',
            'action'     => 'index',
            'canonical'  => true,
        )
    ),
    'dreams_random' => new Zend_Controller_Router_Route_Static(
        '/dreams/random',
        array(
            'controller' => 'dreams',
            'action'     => 'random',
        )
    ),
    'dreams_entry' => new Zend_Controller_Router_Route_Regex(
        'dreams/(\d+)-([a-z0-9][-a-z0-9.]+)',
        array(
            'controller' => 'dreams',
            'action' => 'entry',
        ),
        array(
            1 => 'id',
            2 => 'alias',
        ),
        'dreams/%d-%s'
    ),
    'dreams_entry_old' => new Zend_Controller_Router_Route(
        'dreams/read/entry/:id',
        array(
            'controller' => 'dreams',
            'action'     => 'entry',
            'canonical'  => true,
        )
    ),
    'dreams_archive' => new Zend_Controller_Router_Route_Static(
        'dreams/archive'
    ),
    'dreams_archive_year' => new Zend_Controller_Router_Route(
        'dreams/archive/:year',
        array(
            'controller' => 'dreams',
            'action'     => 'archive',
        ),
        array(
            'year' => '\d{4}',
        )
    ),
    'dreams_archive_month' => new Zend_Controller_Router_Route(
        'dreams/archive/:year/:month',
        array(
            'controller' => 'dreams',
            'action'     => 'archive',
        ),
        array(
            'year'  => '\d{4}',
            'month' => '([1-9]|1[0-2])',
        )
    ),


//*
    'sitemap' => new Zend_Controller_Router_Route_Static(
        'sitemap',
        array(
            'controller' => 'index',
            'action'     => 'sitemap',
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
//*/

    'about' => new Zend_Controller_Router_Route_Static(
        'about',
        array(
            'controller' => 'index',
            'action'     => 'about',
        )
    ),
);