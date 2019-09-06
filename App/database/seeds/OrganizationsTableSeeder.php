<?php

use Illuminate\Database\Seeder;

class OrganizationsTableSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
    
        
        $org_count = 5;
        $adv_in_org = 3;
      
        
        
        for($i = 0; $i < $org_count; $i++ ){
            
            $org_user = new App\User();
            $org_user->name = "Organization" . Str::random(5);
            $org_user->email = Str::random(5) . "@gmail.com";
            $org_user->phone_number = Str::random(5);
            $org_user->email_verified_at = now();
            $org_user->password = bcrypt('123');
            $org_user->save();



            $org = new App\Organization();
            $org->user_id = $org_user->id;
            $org->address = Str::random(5);
            $org->save();



            $role_users = new App\RoleUser();
            $role_users->user_id = $org_user->id;
            $role_users->role_id = 3;
            $role_users->save();

            for($a = 0;$a<$adv_in_org;$a++){
                 
            $adv_user = new App\User();
            $adv_user->name = "Advisor" . Str::random(5);
            $adv_user->email = Str::random(5) . "@gmail.com";
            $adv_user->phone_number = Str::random(5);
            $adv_user->email_verified_at = now();
            $adv_user->password = bcrypt('123');
            $adv_user->save();



            $adv = new App\Advisor();
            $adv->user_id = $adv_user->id;
            $adv->organization_id = $org_user->id;
            $adv->save();



            $role_users = new App\RoleUser();
            $role_users->user_id = $adv_user->id;
            $role_users->role_id = 5;
            $role_users->save();
            }

        }
    }

}

