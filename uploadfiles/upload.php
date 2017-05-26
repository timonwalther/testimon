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

// a flag to see if everything is ok
$success = null;

// file paths to store
$paths= [];

// get file names
$filenames = $file_data['name'];


$target_dir = "upload/";

// loop and process files
for($i=0; $i < count($filenames); $i++){
    
	
	$ext = explode('.', basename($filenames[$i]));
	error_log ("1 ".$file_data['tmp_name']." 2 ".$file_data['name']."||",3,"error.log");
	
    if(move_uploaded_file($file_data['tmp_name'], "uploads/".$file_data['name'])) {
        $success = true;
        $paths[] = $target;
		exec("perl ../perlscript/main.pm");  
		
    } else {
        $success = false;
        break;
    }
	
}

// check and process based on successful status 
if ($success === true) {
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


// return a json encoded response for plugin to process successfully
echo json_encode($output);

?>