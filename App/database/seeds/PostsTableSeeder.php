<?php

use Illuminate\Database\Seeder;

class PostsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        //
        //

        $orgs_user = App\User::all();
        foreach($orgs_user as $orgs){
            $userRoles = $orgs->roles()->pluck('name');//Auth::user()->roles->pluck('name');
            if($userRoles->contains('Organization')){
                $dep_users = App\User::all();
                foreach($dep_users as $deps){
                    $userRoles2 = $deps->roles()->pluck('name');
                    if($userRoles2->contains('Department')){
                        $post = new App\Post;
                        $post->user_id = $orgs->id;
                        $post->student_no = rand(3, 20);
                        $post->department  = $deps->id;
                        $post->min_grade = 3.0;
                        $post->work_area = "Web development";
                        $post->student_benefit = "30 birr per month";
                        $post->applied_count = 0;
                        $post->save();
                    }
                }
            }
        }
    }
}
