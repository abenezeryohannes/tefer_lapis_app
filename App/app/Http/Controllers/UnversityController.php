<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Unversity;
use Auth;

class UnversityController extends Controller
{
    //



    public function editDepartments(){

    }




    public function unversityDepartments(){

        $departments = Auth::user()->unversity->departments;
        return view('University_pages.departments')->with('departments', $departments);
    }



}
