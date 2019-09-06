<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Department extends Model
{
    
    //change it to department_id later
    public function posts(){
        return $this->hasMany('App\Post', 'department', 'user_id');
    }

    public function user(){
        return $this->belongsTo('App\User', 'user_id', 'id');
    }
    
}
