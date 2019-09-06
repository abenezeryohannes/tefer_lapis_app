<?php

namespace App;

use Illuminate\Notifications\Notifiable;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Foundation\Auth\User as Authenticatable;


class User extends Authenticatable
{
    use Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'name', 'email', 'password',
    ];

    /**
     * The attributes that should be hidden for arrays.
     *
     * @var array
     */
    protected $hidden = [
        'password', 'remember_token',
    ];

    /**
     * The attributes that should be cast to native types.
     *
     * @var array
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
    ];



    public function roles(){    
        return $this->belongsToMany('App\Role');
    }

    public function student(){
        return $this->hasOne('App\Student');
    }

    public function unversity(){
        return $this->hasOne('App\Unversity');
    }
    
    public function organization(){
        return $this->hasOne('App\Organization');
    }
    
    public function department(){
        return $this->hasOne('App\department');
    }
    
    public function advisor(){
        return $this->hasOne('App\Advisor');
    }
    public function internships(){
        return $this->hasMany('App\Internship', 'student_id');
    }
}
