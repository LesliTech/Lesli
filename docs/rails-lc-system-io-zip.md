# Zip file creation utility 
Provides an interface to create and handle zip files

## Existing Methods

- **String zip(String relative_path, String[] files_paths)**

	- Params
    	- zip_file (String): The relative path of the zip file to be created. The file will be allocated in lesli/public/tmp until it's released
    	- files (String[]): Array of strings that contain the relative path of the files to be added to the zip file
	- Description
    	- Creates a temporal zip file that contains all requested files and stores it in memory to be either used, stored or sent using an HTPP response
	- Example

```ruby
# We create the zip file
zip_file = LC::System::IO.zip("my_zip_file.zip", "public/storage/assets/images/image1.png", "storage/documents/document1.pdf")

# We do stuff with it, in this case, send it as a response in a controller
Zip::File.open(zip_file) do zip_data
    send_data zip_data, filename: "all_documents_#{Date.today.strftime('%d_%B_%Y')}.zip", type: 'application/zip'
end

```
