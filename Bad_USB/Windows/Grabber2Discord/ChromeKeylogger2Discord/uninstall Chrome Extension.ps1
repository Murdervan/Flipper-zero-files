# Afinstallerer Chrome-udvidelsen
$wshell = New-Object -ComObject wscript.shell
Start-Process chrome.exe example.com
sleep 7
$wshell.AppActivate("chrome.exe")
$wshell.SendKeys("{TAB}") ;sleep -m 500
$wshell.SendKeys("{TAB}") ;sleep -m 500
$wshell.SendKeys("{TAB}") ;sleep -m 500
$wshell.SendKeys("chrome://extensions/") ;sleep -m 500
$wshell.SendKeys("{ENTER}") ;sleep 4
$wshell.SendKeys("{TAB}") ;sleep -m 500
$wshell.SendKeys(" ") ;sleep 2
$wshell.SendKeys("{TAB}") ;sleep -m 500
$wshell.SendKeys("{TAB}") ;sleep -m 500
$wshell.SendKeys("{ENTER}") ;sleep 4
$wshell.SendKeys("{TAB}") ;sleep -m 500
$wshell.SendKeys("{TAB}") ;sleep -m 500
$wshell.SendKeys("{ENTER}") ;sleep 4
$wshell.SendKeys("%{F4}")

# Find stien til Chrome-udvidelsen
$extensionPath = (Get-ChildItem "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Extensions" | Where-Object { $_.Name -eq "McAfee Antivirus" }).FullName

if ($extensionPath) {
    # Fjern udvidelsesmappen og dens indhold
    Remove-Item $extensionPath -Recurse -Force
    Write-Output "Udvidelsen blev fjernet fra stien: $extensionPath"
} else {
    Write-Output "Udvidelsen blev ikke fundet."
}
