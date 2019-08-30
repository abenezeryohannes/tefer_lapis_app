<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreatePostsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('posts', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('user_id');

            $table->unsignedInteger('student_no');
            $table->unsignedBigInteger('department');
            $table->float('min_grade');
            $table->string('work_area');
            $table->string('student_benefit');

            $table->string('applied_count');
            $table->timestamps();
        });

        Schema::table('posts', function (Blueprint $table){
            $table->foreign('department')->references('id')->on('users')->onCascade('delete');
            $table->foreign('user_id')->references('id')->on('users')->onCascade('delete');
        });

        
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('posts');
    }
}
