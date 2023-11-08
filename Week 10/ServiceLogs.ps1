# Define an array of possible options for viewing services
$someArray = @('all', 'stopped', 'running', 'quit')

# Prompt the user to select which services they want to view
Write-Host "What services do you want to view: All Of Them, Running Services, or Stoped Services"
$userView = Read-Host "Enter either: all, running, stopped, or quit"

# Validate user input until it is one of the valid options
while($userView -notin $someArray){
    $userView = Read-Host "Enter either: all, running, stopped, or quit"
}

# Check user selection and display the corresponding services
if($userView -ilike "all"){
    # Display all services
    Get-Service
}
elseif($userView -ilike "running"){
    # Display only running services
    Get-Service | where {$_.Status -ilike "Running"}
}
elseif($userView -ilike "quit"){
    #exit the program
    exit
}
else{
    # Display only stopped services
    Get-Service | where {$_.Status -ilike "Stopped"}
}

