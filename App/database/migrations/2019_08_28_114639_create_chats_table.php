<?php

use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\Migrations\Migration;

class CreateChatsTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::create('chats', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('sender_id');
            $table->unsignedBigInteger('reciever_id');
            $table->string('text');
            $table->timestamps();
        });
        
        
        Schema::table('chats', function (Blueprint $table){
            $table->foreign('sender_id')->references('id')->on('users')->onCascade('delete');
            $table->foreign('reciever_id')->references('id')->on('users')->onCascade('delete');
        });

    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::dropIfExists('chats');
    }
}
