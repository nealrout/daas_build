# List of Docker image names
$dockerImages = @("daas_idx_account", "daas_idx_facility", "daas_idx_asset", "daas_idx_service", "daas_idx_user")

# Python script path inside the container
$pythonScriptPath = "/usr/local/lib/python3.12/site-packages/daas_py_idx/main.py"

# Loop through each image name
foreach ($image in $dockerImages) {
    Write-Host "Finding running containers for image: $image"
    
    # Get the list of running containers created from the image
    $containers = docker ps --filter "ancestor=$image" --format "{{.ID}}"

    # Loop through each container and execute the Python script inside it
    foreach ($container in $containers) {
        Write-Host "Executing script in container: $container (from image: $image)"
        
        # Run Python script inside the container
        docker exec -it $container python3 $pythonScriptPath --full

        # Check the exit status
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Error processing container: $container" -ForegroundColor Red
            break  # Stop execution on error (optional)
        }
    }
}

Write-Host "All containers processed successfully."
