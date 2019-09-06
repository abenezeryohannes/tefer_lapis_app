<?php
namespace App\Http\Controllers;


class Util{

 
    static function  to_time_ago( $time ) { 
      
        // Calculate difference between current 
        // time and given timestamp in seconds 
        $diff = time() - strtotime($time); 
          
        if( $diff < 1 ) {  
            return 'less than 1 second ago';  
        } 
          
        $time_rules = array (  
                    12 * 30 * 24 * 60 * 60 => 'year', 
                    30 * 24 * 60 * 60       => 'month', 
                    24 * 60 * 60           => 'day', 
                    60 * 60                   => 'hour', 
                    60                       => 'minute', 
                    1                       => 'second'
        ); 
      
        foreach( $time_rules as $secs => $str ) { 
              
            $div = $diff / $secs; 
      
            if( $div >= 1 ) { 
                  
                $t = round( $div ); 
                  
                return $t . ' ' . $str .  
                    ( $t > 1 ? 's' : '' ) . ' ago'; 
            } 
        } 
    } 
  
}