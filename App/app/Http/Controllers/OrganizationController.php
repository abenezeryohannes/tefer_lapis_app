<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Auth;

class OrganizationController extends Controller
{
    //
    public function showHome(){
        $posts = Auth::user()->organization->posts;
        return view('Organization.home')->with('posts', $posts);
    }


    public function showAdvisors(){
        $advisors = Auth::user()->organization->advisors;
        return view('Organization.advisors')->with('advisors', $advisors);
    }

    
    public function showRequests(){
        $internships = Auth::user()->organization->internship_requests;
        return view('Organization.requests')->with('internships', $internships);
    }

    
    public function showStudents(){
        $students = Auth::user()->organization->internship_requests->student;
        return view('Organization.students')->with('students', $students);
    }


    //poster_name
    //student_no
    //department
    //work_area
    //min_Grade
    //student_benefit
    //description
    //apply
    //applied_count
    //date    







}
