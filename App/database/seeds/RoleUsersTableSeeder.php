<?php

use Illuminate\Database\Seeder;
use App\RoleUser;
class RoleUsersTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        //RoleUser::truncate();
        $users = App\User::all();
        $roles = App\Role::all();
        $numberofRoles = sizeof($roles);

        for($i = 0;$i<sizeof($users);$i++){
//            $random = rand(0, $numberofRoles-1);
            $role_users = new App\RoleUser();
            $role_users->user_id = $users->get($i)->id;
            $role_users->role_id = $roles->get(rand(0, $numberofRoles-1))->id;
            $role_users->save();
        }
    }
}
