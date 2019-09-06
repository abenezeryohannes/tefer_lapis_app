<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Unversity extends Model
{
    
    public function departments(){
        return $this->hasMany('App\Department', 'university_id', 'user_id');
    }

}
