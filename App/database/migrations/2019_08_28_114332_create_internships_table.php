<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateInternshipsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {

        Schema::create('internships', function (Blueprint $table) {
        
            $table->bigIncrements('id');
            $table->unsignedBigInteger('student_id');
            $table->unsignedBigInteger('organization_id');
            $table->string('work_area')->nullable();
            $table->date('start_date');
            $table->date('end_date');
            $table->unsignedInteger('number_of_days');
            $table->boolean('approved_by_organization');
            $table->boolean('assigned_by_department');
            $table->float('evaluation')->nullable();
            $table->string('attachment')->nullable();
            $table->timestamps();
            
        });


        Schema::table('internships', function (Blueprint $table){
        
            $table->foreign('student_id')->references('id')->on('users')->onCascade('delete');
            $table->foreign('organization_id')->references('id')->on('users')->onCascade('delete');
        
        });


    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('internships');
    }
}
