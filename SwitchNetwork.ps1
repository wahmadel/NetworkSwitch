## Add the required .NET assembly for [System.Windows.MessageBox]
Add-Type -AssemblyName System.Windows.Forms

## Function to get the list of existing netwoek adapters with thier status
function Get-NetworkConnectionStatus {
    $networks = Get-NetAdapter
    $networkName = @{name="NetworkName";Expression={$_.Name}}
    $networkStatus = @{name="NetworkStatus";Expression={$_.Status}}
    
    foreach ($network in $networks) {
        ## Connect to Ethernet if the WiFi is the current connected network
        If($network.Name -like 'Ethernet*' -and ($network.Status -eq 'Disabled' -or $network.Status -ne 'Up')) { Connect-Ethernet break }
        ## Connect to WiFi if the Ethernet is the current connected network
        If($network.Name -like 'Wi-Fi*' -and ($network.Status -eq 'Disabled' -or $network.Status -ne 'Up')) { Connect-WiFi break }
    }
    
    ## Display message box after finishing the proccess
    [System.Windows.Forms.MessageBox]::Show('SwitchNetwork has been done successfully.', 'Information', 'OK', 'Information')
}

## Function to connect to Ethernet and disable WiFi
function Connect-Ethernet {
    ## Enable Ethernet adapter
    Enable-NetAdapter -Name "Ethernet 3" -Confirm:$false
    ## Disable WiFi adapter
    Disable-NetAdapter -Name "Wi-Fi 2" -Confirm:$false
}

## Function to connect to Wifi and disable Ethernet
function Connect-WiFi {
    ## Enable WiFi adapter
    Enable-NetAdapter -Name "Wi-Fi 2" -Confirm:$false
    ## Disable Ethernet adapter
    Disable-NetAdapter -Name "Ethernet 3" -Confirm:$false
    ## Wait for WiFi adapter completing initialization
    Start-Sleep -s 15
    ## Connect to specific SSID
    netsh wlan connect ssid=XXXXXXX name=XXXXXXX
}

## Calling the main function to execute
Get-NetworkConnectionStatus
