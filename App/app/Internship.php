<?php

namespace App;

use Illuminate\Database\Eloquent\Model;

class Internship extends Model
{
    //

    public function organization(){
        return $this->belongsTo('App\User', 'organization_id');
    }

    public function student(){
        return $this->belongsTo('App\Student', 'student_id', 'user_id');
    }
}
