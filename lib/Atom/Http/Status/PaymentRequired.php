<?php
/**
 * HTTP status: 402 Payment Required
 *
 * @author Maxim Khan-Magomedov <maxim.km@gmail.com>
 * @package Atom\Http\Status
 */

namespace Atom\Http\Status;
 
use Atom\Http\Status;

/**
 * HTTP Payment Required
 */
class PaymentRequired extends Status
{
    /**
     * @var int
     */
    protected $code = 402;

    /**
     * @var string
     */
    protected $message = 'Payment Required';
}
