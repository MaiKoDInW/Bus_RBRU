<?php 
  include 'connected.php' 

  $json["error"] = false;
  $json["errmsg"] = "";
  $json["data"] = array();

  $sql = "SELECT * FROM idlatlng ";
  $res = mysqli_query($link, $sql);
  $numrows = mysqli_num_rows($res);
  if($numrows > 0){
     //check if there is any data
     $namelist = array();

     while($array = mysqli_fetch_assoc($res)){
         array_push($json["data"], $array);
         //push fetched array to $json["data"] 
     }
  }else{
      $json["error"] = true;
      $json["errmsg"] = "No any data to show.";
  }

  mysqli_close($link);
  
  header('Content-Type: application/json');
  // tell browser that its a json data
  echo json_encode($json);
?>