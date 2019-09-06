<?php

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Seed the application's database.a
     *
     * @return void
     */
    public function run()
    {
         $this->call(RolesTableSeeder::class);
         $this->call(UniversitiesTableSeeder::class);
         $this->call(OrganizationsTableSeeder::class);
         $this->call(PostsTableSeeder::class);
         $this->call(InternshipsTableSeeder::class);
    }
}
