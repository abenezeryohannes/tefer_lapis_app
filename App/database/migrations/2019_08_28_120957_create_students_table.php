<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateStudentsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('students', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('user_id');
            $table->unsignedBigInteger('university_id');
            $table->unsignedBigInteger('department_id');
            $table->string('student_identification')->nullable();
            $table->string('sex')->nullable();
            $table->float('grade')->nullable();
            $table->integer('year')->nullable();
            $table->timestamps();
        });

        Schema::table('students', function (Blueprint $table){
            $table->foreign('user_id')->references('id')->on('users')->onCascade('delete');
            $table->foreign('university_id')->references('id')->on('users')->onCascade('delete');
            $table->foreign('department_id')->references('id')->on('users')->onCascade('delete');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('students');
    }
}
