<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Organization extends Model
{
    //

    public function posts(){
        return $this->hasMany('App\Post', 'user_id', 'user_id');
    }

    public function user(){
        return $this->belongsTo('App\User');
    }

    public function internship_requests(){
        return $this->hasMany('App\Internship', 'organization_id', 'user_id');
    }

    

    public function advisors(){
        return $this->hasMany('App\Advisor', 'organization_id', 'user_id');
    }

    

}
