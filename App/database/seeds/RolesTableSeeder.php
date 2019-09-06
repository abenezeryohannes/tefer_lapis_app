<?php

use Illuminate\Database\Seeder;
use App\Role;
class RolesTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
           //Role::truncate();
           $roles = [
            "Admin",
            "University",
            "Organization",
            "Department",
            "Advisor",
            "Student"];

    for($i=0;$i<sizeof($roles);$i++){
        $role = new Role();
        $role->name = $roles[$i];
        $role->save();
    }
    }
}
