		// initialize with defaults
		$("#input-id").fileinput();
		// with plugin options
		$("#input-id").fileinput({'showUpload':false, 'previewFileType':'any'});
		<!-- must load the font-awesome.css for this example -->
	
		$("#input-ke-2").fileinput({
		uploadAsync: true, 
		theme: "explorer",
		uploadAsync: true,
		uploadUrl: URL,
		minFileCount: 1,
		maxFileCount: 100,
		overwriteInitial: false,
		initialPreviewAsData: true, // defaults markup  
		preferIconicPreview: true, // this will force thumbnails to display icons for following file extensions
		previewFileIconSettings: { // configure your icon file extensions
			'doc': '<i class="fa fa-file-word-o text-primary"></i>',
			'xls': '<i class="fa fa-file-excel-o text-success"></i>',
			'ppt': '<i class="fa fa-file-powerpoint-o text-danger"></i>',
			'pdf': '<i class="fa fa-file-pdf-o text-danger"></i>',
			'zip': '<i class="fa fa-file-archive-o text-muted"></i>',
			'htm': '<i class="fa fa-file-code-o text-info"></i>',
			'txt': '<i class="fa fa-file-text-o text-info"></i>',
			'mov': '<i class="fa fa-file-movie-o text-warning"></i>',
			'mp3': '<i class="fa fa-file-audio-o text-warning"></i>',
			// note for these file types below no extension determination logic 
			// has been configured (the keys itself will be used as extensions)
			'jpg': '<i class="fa fa-file-photo-o text-danger"></i>', 
			'gif': '<i class="fa fa-file-photo-o text-muted"></i>', 
			'png': '<i class="fa fa-file-photo-o text-primary"></i>'    
		},
		previewFileExtSettings: { // configure the logic for determining icon file extensions
			'zip': function(ext) {
				return ext.match(/(zip|rar|tar|gzip|gz|7z)$/i);
			},
			'htm': function(ext) {
				return ext.match(/(htm|html)$/i);
			},
			'txt': function(ext) {
				return ext.match(/(txt|ini|csv|java|php|js|css)$/i);
			},
		}
		});