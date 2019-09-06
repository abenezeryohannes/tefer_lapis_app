<?php

use Illuminate\Database\Seeder;

class UniversitiesTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        //
        

        $unv_count = 1;
        $dep_in_unv_count = 3;
        $stud_in_dep_count = 5;

        for($i = 0; $i < $unv_count; $i++ ){
            $unv_user = new App\User();
            $unv_user->name = "University" . Str::random(5);
            $unv_user->email = Str::random(5) . "@gmail.com";
            $unv_user->phone_number = Str::random(5);
            $unv_user->email_verified_at = now();
            $unv_user->password = bcrypt('123');
            $unv_user->save();

            $unv = new App\Unversity();
            $unv->address = Str::random(6);
            $unv->user_id = $unv_user->id;
            $unv->save();

            $role_users = new App\RoleUser();
            $role_users->user_id = $unv_user->id;
            $role_users->role_id = 2;
            $role_users->save();


            for($d = 0; $d <$dep_in_unv_count;$d++){
                $dep_user = new App\User();
                $dep_user->name = "Department" . Str::random(5);
                $dep_user->email = Str::random(5) . "@gmail.com";
                $dep_user->phone_number = Str::random(5);
                $dep_user->email_verified_at = now();
                $dep_user->password = bcrypt('123');
                $dep_user->save();

                
                $dep = new App\Department();
                $dep->user_id = $dep_user->id;
                $dep->university_id = $unv_user->id;
                $dep->save();

                $role_users = new App\RoleUser();
                $role_users->user_id = $dep_user->id;
                $role_users->role_id = 4;
                $role_users->save();



               

                for($s = 0 ; $s < $stud_in_dep_count ; $s++ ){
                    $stud_user = new App\User();
                    $stud_user->name = "Student" . Str::random(5);
                    $stud_user->email = Str::random(5) . "@gmail.com";
                    $stud_user->phone_number = Str::random(5);
                    $stud_user->email_verified_at = now();
                    $stud_user->password = bcrypt('123');
                    $stud_user->save();
    

                    $stud = new App\Student();
                    $stud->user_id = $stud_user->id;
                    $stud->university_id = $unv_user->id;
                    $stud->department_id = $dep_user->id;
                    $stud->save();

                    $role_users = new App\RoleUser();
                    $role_users->user_id = $stud_user->id;
                    $role_users->role_id = 6;
                    $role_users->save();
                }



                // for($a = 0 ; $a < $adv_in_dep_count ; $a++ ){

                //     $adv_user = new App\User();
                //     $adv_user->name = Str::random(6);
                //     $adv_user->email = Str::random(5);
                //     $adv_user->phone_number = Str::random(5);
                //     $adv_user->email_verified_at = now();
                //     $adv_user->password = bcrypt('123');
                //     $adv_user->save();


                //     $adv = new App\Advisor();
                //     $adv->user_id = $adv_user->id;
                //     $adv->university_id = $org->id;


                // }


            }


        }
    }
}
