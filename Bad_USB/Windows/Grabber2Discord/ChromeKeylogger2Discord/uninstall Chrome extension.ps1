# Function to uninstall Chrome extension using Extension Management API
function Uninstall-ChromeExtension {
    param (
        [string]$ExtensionId
    )

    $ChromePath = 'C:\Program Files\Google\Chrome\Application\chrome.exe'
    $UninstallUrl = 'https://chrome.google.com/webstore/migrate/' + $ExtensionId

    # Open Chrome to the page to uninstall the extension
    Start-Process -FilePath $ChromePath -ArgumentList $UninstallUrl

    # Wait a short moment to ensure Chrome is opened
    Start-Sleep -Seconds 5

    # Find the Chrome window
    $ChromeWindow = Get-Process | Where-Object {$_.MainWindowTitle -like '*Chrome*'}

    if ($ChromeWindow) {
        # Activate the Chrome window
        $ActivateWindow = Add-Type -AssemblyName System.Windows.Forms -PassThru -MemberDefinition '
            [DllImport("user32.dll")] public static extern bool SetForegroundWindow(IntPtr hWnd);
        '
        $ActivateWindow::SetForegroundWindow($ChromeWindow.MainWindowHandle)
        Start-Sleep -Seconds 1

        # Send keystrokes to open the extension page
        [System.Windows.Forms.SendKeys]::SendWait('{ESC}')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('{TAB}')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')

        # Wait to ensure the extension page is opened
        Start-Sleep -Seconds 3

        # Send keystrokes to uninstall the extension
        [System.Windows.Forms.SendKeys]::SendWait('{TAB}')
        Start-Sleep -Milliseconds 500
        [System.Windows.Forms.SendKeys]::SendWait('{ENTER}')

        # Wait a short moment to ensure the extension is uninstalled
        Start-Sleep -Seconds 5

        # Close the Chrome window
        $ChromeWindow.CloseMainWindow()
    }
}

# Function to find and uninstall the extension
function FindAndUninstall-ChromeExtension {
    $ChromeUserDataPath = $env:LOCALAPPDATA + '\Google\Chrome\User Data'
    
    # Find all folders with extension IDs
    $ExtensionFolders = Get-ChildItem -Path $ChromeUserDataPath -Directory -Filter '*' --ErrorAction SilentlyContinue
    
    if ($ExtensionFolders) {
        foreach ($Folder in $ExtensionFolders) {
            $ExtensionId = $Folder.Name
            Write-Host 'Found Extension ID: ' $ExtensionId
            
            # Uninstall the extension
            Uninstall-ChromeExtension -ExtensionId $ExtensionId
        }
    } else {
        Write-Host 'No Chrome extensions found.'
    }
}

# Call the function to find and uninstall the extension
FindAndUninstall-ChromeExtension
