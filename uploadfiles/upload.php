<?php

declare(strict_types=1);

use PHPUnit\Framework\TestCase;

class UPLOADER {

	private $file_data; 
	private $success; 
	private $target_dir; 
	private $paths;
	private $filenames; 
	private $output;
	private $perl_command;
	private $file_count;
	
	
	function __construct () {
		
		$this->file_data 	= "";
		$this->success 		= null;	
		$this->target_dir 	= "upload/";
		//$perl_command		= 'perl ../perlscript/main.pm';
		$this->paths		= []; // file paths to store
	    $this->output 		= [];
		$this->file_count	= 0;
	}
	
    public function doUpload () {
		
		// 'file_data' refers to your file input name attribute
		if (empty($_FILES['input-ke-2'])) 
		{
			echo json_encode(['error'=>'No files found for upload.']); 
			// or you can throw an exception 
			return; // terminate
		}
		
		// get the files posted
		$this->file_data 	= $_FILES['input-ke-2'];
		// get file names
		$this->filenames 	= $this->file_data['name'];
	
		$this->file_count 	= count($this->filenames);
	
	
		// loop and process files
		for($i=0; $i < $this->file_count ; $i++){
		
		
			$ext = explode('.', basename($this->filenames[$i]));
			error_log ("1 ".$this->file_data['tmp_name']." 2 ".$this->file_data['name']."||",3,"error.log");
		
			if(move_uploaded_file($this->file_data['tmp_name'], "uploads/".$this->file_data['name'])) {
				$this->success = true;
				$this->paths[] = $target;
				exec("perl ../perlscript/main.pm");  
				unlink ("uploads/".$this->file_data['name']);

			} else {
				$this->success = false;
				break;
			}
		}//end for

		// check and process based on successful status 
		if ($this->success === true) {
			// for example you can get the list of files uploaded this way
			$this->output = ['uploaded' => $this->paths];
		} elseif ($this->success === false) {
			$this->output = ['error'=>'Error while uploading images. Contact the system administrator'];
			// delete any uploaded files
			foreach ($this->paths as $file) {
				unlink($file);
			}
		} else {
			$this->output = ['error'=>'No files were processed.'];
		}
		// return a json encoded response for plugin to process successfully
		echo json_encode($this->output);
		
		$myfile 	= fopen("uploads/uploadlog.json", "w") or die ("Unable to create and open jsonfile.json!");
		$txt 		= '{'."\r\n".'"testframework": "nunit",'."\r\n".'"filesnumber": "'.$this->file_count.'"'."\r\n".'}';
		fwrite($myfile, $txt);
		fclose($myfile);		
	}//end doUpload function	
		
}//end class UPLOADER

$upload = new UPLOADER();
$upload->doUpload();

?>