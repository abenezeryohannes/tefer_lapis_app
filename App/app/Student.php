<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Student extends Model
{
    //
    public function department(){
        return $this->belongsTo('App\Department', 'department_id', 'user_id');
    }

    public function user(){
        return $this->belongsTo('App\User', 'user_id', 'id');
    }
}
