<?php
return array(
    'home' => new Zend_Controller_Router_Route_Static(
        '/'
    ),

    'tos' => new Zend_Controller_Router_Route_Static(
        '/tos',
        array(
            'controller' => 'user',
            'action'     => 'agreement',
        )
    ),
    'tos_old' => new Zend_Controller_Router_Route_Static(
        '/user/tos',
        array(
            'controller' => 'user',
            'action'     => 'agreement',
            'canonical'  => true,
        )
    ),

    'privacy' => new Zend_Controller_Router_Route_Static(
        '/privacy',
        array(
            'controller' => 'user',
            'action'     => 'privacy',
        )
    ),
    'privacy_old' => new Zend_Controller_Router_Route_Static(
        '/user/privacy',
        array(
            'controller' => 'user',
            'action'     => 'privacy',
            'canonical'  => true,
        )
    ),
    'profile_ozgg' => new Zend_Controller_Router_Route_Static(
        '/user/profile/dr_von_ozgg',
        array(
            'controller' => 'user',
            'action'     => 'profile',
            'of'         => 'dr_von_ozgg',
            'canonical'  => true,
        )
    ),

    'user_register' => new Zend_Controller_Router_Route_Static(
        '/register',
        array(
            'controller' => 'user',
            'action'     => 'register',
        )
    ),
    'user_register_old' => new Zend_Controller_Router_Route_Static(
        '/users/register',
        array(
            'controller' => 'user',
            'action'     => 'register',
            'canonical'  => true,
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
    'user_rating' => new Zend_Controller_Router_Route_Static(
        '/users/rating',
        array(
            'controller' => 'user',
            'action'     => 'rating',
        )
    ),
    'user_list' => new Zend_Controller_Router_Route_Static(
        '/users/list',
        array(
            'controller' => 'user',
            'action'     => 'list',
        )
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

    'posting_comments_create' => new Zend_Controller_Router_Route(
        '/posts/:id/comments',
        array(
            'controller' => 'posting',
            'action' => 'comments',
        ),
        array(
            'id' => '\d+',
        )
    ),

    'forum' => new Zend_Controller_Router_Route_Static(
        '/forum'
    ),
    'forum_community' => new Zend_Controller_Router_Route(
        '/forum/communities/:id',
        array(
            'controller' => 'forum',
            'action'     => 'community',
        )
    ),
    'forum_community_old' => new Zend_Controller_Router_Route(
        '/forum/contents/of/:id',
        array(
            'controller' => 'forum',
            'action'     => 'community',
            'canonical'  => true,
        )
    ),
    'forum_community_new' => new Zend_Controller_Router_Route(
        '/forum/communities/:id/new',
        array(
            'controller' => 'forum',
            'action'     => 'new',
        )
    ),
    'forum_entry' => new Zend_Controller_Router_Route_Regex(
        'forum/posts/(\d+)-([a-z0-9][-a-z0-9.]+)',
        array(
            'controller' => 'forum',
            'action'     => 'entry',
        ),
        array(
            1 => 'id',
            2 => 'alias',
        ),
        'forum/posts/%d-%s'

    ),
    'forum_entry_old' => new Zend_Controller_Router_Route(
        '/forum/read/entry/:id',
        array(
            'controller' => 'forum',
            'action'     => 'entry',
            'canonical'  => true,
        )
    ),
    'forum_edit_entry' => new Zend_Controller_Router_Route(
        '/forum/posts/:id/edit',
        array(
            'controller' => 'forum',
            'action' => 'edit',
        ),
        array(
            'id' => '\d+',
        )
    ),

    'dreams' => new Zend_Controller_Router_Route_Static(
        '/dreams'
    ),
    'dreams_new' => new Zend_Controller_Router_Route_Static(
        '/dreams/new'
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
            'action'     => 'entry',
        ),
        array(
            1 => 'id',
            2 => 'alias',
        ),
        'dreams/%d-%s'
    ),
    'dreams_entry_old' => new Zend_Controller_Router_Route(
        '/dreams/read/entry/:id',
        array(
            'controller' => 'dreams',
            'action'     => 'entry',
            'canonical'  => true,
        )
    ),
    'dreams_edit_entry' => new Zend_Controller_Router_Route(
        '/dreams/:id/edit',
        array(
            'controller' => 'dreams',
            'action' => 'edit',
        ),
        array(
            'id' => '\d+',
        )
    ),
    'dreams_tagged' => new Zend_Controller_Router_Route(
        '/dreams/tagged/:tag',
        array(
            'controller' => 'dreams',
            'action'     => 'tagged',
        )
    ),
    'dreams_tagged_old' => new Zend_Controller_Router_Route(
        '/dreams/read/tag/:tag',
        array(
            'controller' => 'dreams',
            'action'     => 'tagged',
            'canonical'  => true,
        )
    ),
    'dreams_tagged_older' => new Zend_Controller_Router_Route(
        '/dreams/read/symbol/:tag',
        array(
            'controller' => 'dreams',
            'action'     => 'tagged',
            'canonical'  => true,
        )
    ),
    'dreams_author' => new Zend_Controller_Router_Route(
        '/dreams/of/:login',
        array(
            'controller' => 'dreams',
            'action'     => 'author',
        )
    ),
    'dreams_author_old' => new Zend_Controller_Router_Route(
        '/dreams/read/author/:login',
        array(
            'controller' => 'dreams',
            'action'     => 'author',
            'canonical'  => true,
        )
    ),
    'dreams_author_older' => new Zend_Controller_Router_Route(
        '/dreams/read/user/:login',
        array(
            'controller' => 'dreams',
            'action'     => 'author',
            'canonical'  => true,
        )
    ),
    'dreams_archive' => new Zend_Controller_Router_Route_Static(
        '/dreams/archive'
    ),
    'dreams_archive_year' => new Zend_Controller_Router_Route(
        '/dreams/archive/:year',
        array(
            'controller' => 'dreams',
            'action'     => 'archive',
        ),
        array(
            'year' => '\d{4}',
        )
    ),
    'dreams_archive_month' => new Zend_Controller_Router_Route(
        '/dreams/archive/:year/:month',
        array(
            'controller' => 'dreams',
            'action'     => 'archive',
        ),
        array(
            'year'  => '\d{4}',
            'month' => '([1-9]|1[0-2])',
        )
    ),
    'dreams_calendar' => new Zend_Controller_Router_Route_Static(
        '/dreams/calendar',
        array(
            'controller' => 'dreams',
            'action' => 'archive',
            'canonical'  => true,
        )
    ),
    'dreams_calendar_year' => new Zend_Controller_Router_Route(
        '/dreams/calendar/:year',
        array(
            'controller' => 'dreams',
            'action'     => 'archive',
            'canonical'  => true,
        ),
        array(
            'year' => '\d{4}',
        )
    ),
    'dreams_calendar_month' => new Zend_Controller_Router_Route(
        '/dreams/calendar/:year/:month',
        array(
            'controller' => 'dreams',
            'action'     => 'archive',
            'canonical'  => true,
        ),
        array(
            'year'  => '\d{4}',
            'month' => '([1-9]|1[0-2])',
        )
    ),

    'fun' => new Zend_Controller_Router_Route_Static(
        '/fun',
        array(
            'controller' => 'index',
            'action'     => 'fun',
        )
    ),
    'fun_rave' => new Zend_Controller_Router_Route_Static(
        '/fun/rave',
        array(
            'controller' => 'dreams',
            'action'     => 'rave',
        )
    ),



    'entities' => new Zend_Controller_Router_Route_Static(
        '/entities'
    ),
    'entities_old' => new Zend_Controller_Router_Route_Static(
        '/entities/read',
        array(
            'controller' => 'entities',
            'action'     => 'index',
            'canonical'  => true,
        )
    ),
    'entities_entry' => new Zend_Controller_Router_Route_Regex(
        'entities/(\d+)-([a-z0-9][-a-z0-9.]+)',
        array(
            'controller' => 'entities',
            'action'     => 'entry',
        ),
        array(
            1 => 'id',
            2 => 'alias',
        ),
        'entities/%d-%s'
    ),
    'entities_entry_old' => new Zend_Controller_Router_Route(
        '/entities/read/entry/:title',
        array(
            'controller' => 'entities',
            'action'     => 'entry',
            'canonical'  => true,
        )
    ),
    'entities_new' => new Zend_Controller_Router_Route_Static(
        '/entities/new'
    ),
    'entities_edit_entry' => new Zend_Controller_Router_Route(
        '/entities/:id/edit',
        array(
            'controller' => 'entities',
            'action' => 'edit',
        ),
        array(
            'id' => '\d+',
        )
    ),

    'dreambook' => new Zend_Controller_Router_Route_Static(
        '/dreambook'
    ),
    'dreambook_new' => new Zend_Controller_Router_Route_Static(
        '/dreambook/new'
    ),
    'dreambook_view' => new Zend_Controller_Router_Route_Static(
        '/dreambook/view',
        array(
            'controller' => 'dreambook',
            'action'     => 'index',
            'canonical'  => true,
        )
    ),
    'dreambook_letter' => new Zend_Controller_Router_Route(
        '/dreambook/read/:letter',
        array(
            'controller' => 'dreambook',
            'action'     => 'letter',
        )
    ),
    'dreambook_view_letter' => new Zend_Controller_Router_Route(
        '/dreambook/view/:letter',
        array(
            'controller' => 'dreambook',
            'action'     => 'letter',
            'canonical'  => true,
        )
    ),
    'dreambook_entry' => new Zend_Controller_Router_Route(
        '/dreambook/read/:letter/:symbol',
        array(
            'controller' => 'dreambook',
            'action'     => 'entry',
        )
    ),
    'dreambook_entry_older' => new Zend_Controller_Router_Route(
        '/dreambook/view/:letter/:symbol',
        array(
            'controller' => 'dreambook',
            'action'     => 'entry',
            'canonical'  => true,
        )
    ),
    'dreambook_letter_old' => new Zend_Controller_Router_Route(
        '/dreambook/read/letter/:letter',
        array(
            'controller' => 'dreambook',
            'action'     => 'letter',
            'canonical'  => true,
        )
    ),
    'dreambook_entry_old' => new Zend_Controller_Router_Route(
        '/dreambook/read/entry/:symbol',
        array(
            'controller' => 'dreambook',
            'action'     => 'entry',
            'canonical'  => true,
        )
    ),
    'dreambook_edit_entry' => new Zend_Controller_Router_Route(
        '/dreambook/:id/edit',
        array(
            'controller' => 'dreambook',
            'action' => 'edit',
        ),
        array(
            'id' => '\d+',
        )
    ),

    'statistics' => new Zend_Controller_Router_Route_Static(
        '/statistics',
        array(
            'controller' => 'statistics',
            'action'     => 'index',
        )
    ),
    'statistics_symbols' => new Zend_Controller_Router_Route_Static(
        '/statistics/symbols',
        array(
            'controller' => 'statistics',
            'action'     => 'symbols',
        )
    ),
    'statistics_symbols_old' => new Zend_Controller_Router_Route_Static(
        '/symbols',
        array(
            'controller' => 'statistics',
            'action'     => 'symbols',
            'canonical'  => true,
        )
    ),

    'sitemap' => new Zend_Controller_Router_Route_Static(
        '/sitemap',
        array(
            'controller' => 'index',
            'action'     => 'sitemap',
        )
    ),

    'articles' => new Zend_Controller_Router_Route_Static(
        '/articles'
    ),
    'articles_new' => new Zend_Controller_Router_Route_Static(
        '/articles/new'
    ),
    'articles_read' => new Zend_Controller_Router_Route_Static(
        '/articles/read',
        array(
            'controller' => 'articles',
            'action'     => 'index',
            'canonical'  => true,
        )
    ),
    'articles_read_blog' => new Zend_Controller_Router_Route_Static(
        '/blog/read',
        array(
            'controller' => 'articles',
            'action'     => 'index',
            'canonical'  => true,
        )
    ),
    'articles_blog' => new Zend_Controller_Router_Route_Static(
        '/blog',
        array(
            'controller' => 'articles',
            'action'     => 'index',
            'canonical'  => true,
        )
    ),
    'articles_blog_tags' => new Zend_Controller_Router_Route(
        '/blog/tags/:tag',
        array(
            'controller' => 'articles',
            'action'     => 'tags',
        )
    ),
    'articles_blog_read' => new Zend_Controller_Router_Route(
        '/blog/read/:entry',
        array(
            'controller' => 'articles',
            'action'     => 'index',
            'canonical'  => true,
        )
    ),
    'articles_entry' => new Zend_Controller_Router_Route_Regex(
        'articles/(\d+)-([a-z0-9][-a-z0-9.]+)',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
        ),
        array(
            1 => 'id',
            2 => 'alias',
        ),
        'articles/%d-%s'
    ),
    'articles_edit_entry' => new Zend_Controller_Router_Route(
        '/articles/:id/edit',
        array(
            'controller' => 'articles',
            'action'     => 'edit',
        ),
        array(
            'id' => '\d+',
        )
    ),
    'articles_read_old_2884' => new Zend_Controller_Router_Route_Static(
        '/articles/read/entry/how-to-remember-dreams',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
            'id'         => '2884',
        )
    ),
    'articles_read_older_2884' => new Zend_Controller_Router_Route_Static(
        '/articles/read/how-to-remember-dreams',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
            'id'         => '2884',
        )
    ),
    'articles_read_old_2885' => new Zend_Controller_Router_Route_Static(
        '/articles/read/entry/how-to-heal-insomnia',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
            'id'         => '2885',
        )
    ),
    'articles_read_old_2886' => new Zend_Controller_Router_Route_Static(
        '/articles/read/entry/how-to-understand-dreams',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
            'id'         => '2886',
        )
    ),
    'articles_read_old_2887' => new Zend_Controller_Router_Route_Static(
        '/articles/read/entry/polyphasic-sleep',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
            'id'         => '2887',
        )
    ),
    'articles_read_older_2887' => new Zend_Controller_Router_Route_Static(
        '/articles/read/polyphasic-sleep',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
            'id'         => '2887',
        )
    ),
    'articles_read_old_2888' => new Zend_Controller_Router_Route_Static(
        '/articles/read/entry/how-to-sleep-faster',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
            'id'         => '2888',
        )
    ),
    'articles_read_old_2889' => new Zend_Controller_Router_Route_Static(
        '/articles/read/entry/dream-interpretation-giudelines',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
            'id'         => '2889',
        )
    ),
    'articles_read_older_2889' => new Zend_Controller_Router_Route_Static(
        '/articles/read/dream-interpretation-giudelines',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
            'id'         => '2889',
        )
    ),
    'articles_read_old_2890' => new Zend_Controller_Router_Route_Static(
        '/articles/read/entry/lilth-and-selene-mystery',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
            'id'         => '2890',
        )
    ),
    'articles_read_old_2891' => new Zend_Controller_Router_Route_Static(
        '/articles/read/entry/sleeptracker',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
            'id'         => '2891',
        )
    ),
    'articles_read_old_2892' => new Zend_Controller_Router_Route_Static(
        '/articles/read/entry/twilight-time-has-come',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
            'id'         => '2892',
        )
    ),
    'articles_read_old_2983' => new Zend_Controller_Router_Route_Static(
        '/articles/read/entry/virtual-machine',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
            'id'         => '2983',
        )
    ),
    'articles_read_entry_old' => new Zend_Controller_Router_Route(
        '/articles/read/entry/:id',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
        )
    ),
    'articles_blog_entry' => new Zend_Controller_Router_Route(
        '/blog/read/entry/:id',
        array(
            'controller' => 'articles',
            'action'     => 'entry',
            'canonical'  => true,
        )
    ),
    'articles_calendar' => new Zend_Controller_Router_Route(
        '/blog/calendar',
        array(
            'controller' => 'articles',
            'action'     => 'calendar',
            'canonical'  => true,
        )
    ),
    'articles_calendar_year' => new Zend_Controller_Router_Route(
        '/blog/calendar/:year',
        array(
            'controller' => 'articles',
            'action'     => 'calendar',
            'canonical'  => true,
        )
    ),
    'articles_calendar_month' => new Zend_Controller_Router_Route(
        '/blog/calendar/:year/:month',
        array(
            'controller' => 'articles',
            'action'     => 'calendar',
            'canonical'  => true,
        )
    ),

    'feed' => new Zend_Controller_Router_Route_Static(
        '/rss',
        array(
            'controller' => 'posting',
            'action'     => 'rss',
        )
    ),

    'about' => new Zend_Controller_Router_Route_Static(
        '/about',
        array(
            'controller' => 'index',
            'action'     => 'about',
        )
    ),
);