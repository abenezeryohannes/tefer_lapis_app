<?php

namespace App\Http\Middleware;

use Closure;
use Auth;

class CheckUniversity
{
    /**
     * Handle an incoming request.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  \Closure  $next
     * @return mixed
     */
    public function handle($request, Closure $next)
    {
        $userRoles = Auth::user()->roles->pluck('name');
        
        if(!$userRoles->contains('University')){
            return redirect('/home');
        }
        
        return $next($request);
    }
}
