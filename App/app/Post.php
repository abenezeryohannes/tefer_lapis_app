<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Post extends Model
{
    //
    public function department(){
        return $this->belongsTo('App\User', 'department', 'id');
    }

    public function poster(){
        return $this->belongsTo('App\User', 'user_id');
    }
    
    
}
