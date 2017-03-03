<?php

// 'file_data' refers to your file input name attribute
if (empty($_FILES['input-ke-2'])) 
{
    echo json_encode(['error'=>'No files found for upload.']); 
    // or you can throw an exception 
    return; // terminate
}

// get the files posted
$file_data = $_FILES['input-ke-2'];

// get user id posted
//$userid = empty($_POST['userid']) ? '' : $_POST['userid'];

// get user name posted
//$username = empty($_POST['username']) ? '' : $_POST['username'];

// a flag to see if everything is ok
$success = null;

// file paths to store
$paths= [];

// get file names
$filenames = $file_data['name'];


$target_dir = "upload/";
//$target_file = $target_dir . basename($_FILES["fileToUpload"]["name"]);


// loop and process files
for($i=0; $i < count($filenames); $i++){
    $ext = explode('.', basename($filenames[$i]));
	//error_log ("ext  ".$ext,3,"error.log");
	
    //$target = "uploads" . DIRECTORY_SEPARATOR . md5(uniqid()) . "." . array_pop($ext);
	//error_log ("beginntarget  ".$target." endtarget",3,"error.log");
	//$success = true;
	
	
    if(move_uploaded_file($file_data['tmp_name'], "uploads/".$file_data['name'])) {
        $success = true;
        $paths[] = $target;
    } else {
        $success = false;
        break;
    }
	
}
//error_log ("4",3,"error.log");

// check and process based on successful status 
if ($success === true) {
    // call the function to save all data to database
    // code for the following function `save_data` is not 
    // mentioned in this example
    //save_data($userid, $username, $paths);

    // store a successful response (default at least an empty array). You
    // could return any additional response info you need to the plugin for
    // advanced implementations.
    $output = [];
    // for example you can get the list of files uploaded this way
    $output = ['uploaded' => $paths];
} elseif ($success === false) {
    $output = ['error'=>'Error while uploading images. Contact the system administrator'];
    // delete any uploaded files
    foreach ($paths as $file) {
        unlink($file);
    }
} else {
    $output = ['error'=>'No files were processed.'];
}


//error_log ("5",3,"error.log");


// return a json encoded response for plugin to process successfully
echo json_encode($output);


//error_log("Say hey",3, "error.log");

?>