<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "we b" middleware group. Now create something great!
|
*/


Route::group(['middleware' => ['auth']], function(){
    Route::get('/user', 'DemoController@userDemo')->name('user');
    Route::group(['middleware' => ['university']], function(){
            Route::get('/admin', 'DemoController@adminDemo')->name('admin');
    });
});




Auth::routes(['register'=>false]);

Route::get('/home', 'HomeController@index')->name('home');
Route::get('/unversityDepartments', 'UnversityController@unversityDepartments')->name('unversity_departments');
Route::get('/studentRequest', 'StudentController@showRequests')->name('student_request');
Route::get('/studentOrganization', 'StudentController@showOrganization')->name('show_organization');

Route::get('/showAdvisors', 'OrganizationController@showAdvisors')->name('org_advisors');
Route::get('/showHome', 'OrganizationController@showHome')->name('org_home');
Route::get('/showRequests', 'OrganizationController@showRequests')->name('org_requests');
Route::get('/showStudents', 'OrganizationController@showStudents')->name('org_students');


Route::get('/', function () {
    return view('welcome');
});

Route::post('login/custom', [
    'uses' =>'LoginController@login',
    'as' => 'login.custom'
    ]);
