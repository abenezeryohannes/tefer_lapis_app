<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Internship;
use App\Organization;
use Auth;
class StudentController extends Controller
{
    //

    public function showRequests(){
        $internships = Auth::user()->internships;
        return view('Student_pages.request')->with('internships', $internships);
    }
    public function showOrganization(){
        $orgs = Organization::all();
        return view('Student_pages.organizations')->with('orgs', $orgs);
    }

    public function showProfile(){
        $user = Auth::user();
        return view('Student_pages.profile')->with('user', $user);
    }
    

}
