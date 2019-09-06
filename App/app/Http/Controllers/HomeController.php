<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Auth;
use App\Post;

class HomeController extends Controller
{
    /**
     * Create a new controller instance.
     *
     * @return void
     */
    public function __construct()
    {
        $this->middleware('auth');
    }

    /**
     * Show the application dashboard.
     *
     * @return \Illuminate\Contracts\Support\Renderable
     */
    public function index()
    {
        
        
        $userRoles = Auth::user()->roles->pluck('name');
        
        if($userRoles->contains('Student')){
            //App\User::find($intern->student->department_id)->name
            $post = Auth::user()->student->department->posts;
            //dd($post);
            return view('Student_pages.home')->with('posts', $post);
        }
        else if($userRoles->contains('University')){
            $post = Post::all();
        }else if($userRoles->contains('Organization')){
            return view('Organization.home')->with('posts', Auth::user()->organization->posts);
        }
       
       // $post = Auth::user()->unversity->department->posts;
        return view('home')->with('posts', $post);
    }
}
