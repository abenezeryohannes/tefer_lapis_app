<?php

use Illuminate\Database\Seeder;

class InternshipsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        //
        //student_id
        //organization_id
        //start_date
        //end_date
        //number_of_days
        //approved_by_organization
        //Signed_by_department
        //evaluation
        //attachment


        $students = App\User::all();

        foreach($students as $stud){

            $userRoles = $stud->roles->pluck('name');
        
            if($userRoles->contains('Student')){
            
                $orgs = App\Organization::all();
                
                foreach($orgs as $org){

                    $intern = new App\Internship();
                    $intern->student_id = $stud->id;
                    $intern->organization_id = $org->user_id;
                    $intern->work_area = "Web Development";
                    $intern->start_date = now();
                    $intern->end_date = now();
                    $intern->number_of_days = 60;
                    $intern->approved_by_organization = false;
                    $intern->assigned_by_department = false;
                    $intern->evaluation = 0.0;
                    $intern->attachment = null;
                    $intern->save();
                }
            }
        }

    }
}
