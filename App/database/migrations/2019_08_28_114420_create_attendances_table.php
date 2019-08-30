<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateAttendancesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('attendances', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('student_id');
            $table->unsignedBigInteger('advisor_id');
            $table->date('date');
            $table->timestamps();
        });

        Schema::table('attendances', function (Blueprint $table){
            $table->foreign('student_id')->references('id')->on('users')->onCascade('delete');
            $table->foreign('advisor_id')->references('id')->on('users')->onCascade('delete');
        });

    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('attendances');
    }
}
