<#
    Title: Zipography Privacy Tool v1.0
    Copyright© 2024 Magdy Aloxory. All rights reserved.
    Contact: maloxory@gmail.com
#>

# Check if the script is running with administrator privileges
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Relaunch the script with administrator privileges
    Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    exit
}


function Hide-ZipInPhoto {
    # Prompt for input image file
    $image = Read-Host "Enter the path of the image file (e.g., C:\path\to\photo.jpg)"
    $image = "`"$image`""

    # Prompt for input zip file
    $zip = Read-Host "Enter the path of the zip file (e.g., C:\path\to\file.zip)"
    $zip = "`"$zip`""

    # Prompt for output file name
    $output = Read-Host "Enter the path for the output file (e.g., C:\path\to\output.jpg)"
    $output = "`"$output`""

    # Combine the image and zip file
    $imageBytes = [System.IO.File]::ReadAllBytes($image.Trim('"'))
    $zipBytes = [System.IO.File]::ReadAllBytes($zip.Trim('"'))
    $outputBytes = New-Object byte[] ($imageBytes.Length + $zipBytes.Length)
    $imageBytes.CopyTo($outputBytes, 0)
    $zipBytes.CopyTo($outputBytes, $imageBytes.Length)
    [System.IO.File]::WriteAllBytes($output.Trim('"'), $outputBytes)

    # Confirm completion
    Write-Host "`nThe files have been locked into $output.`n" -ForegroundColor Yellow
    pause
}

function Unhide-ZipFromPhoto {
    # Prompt for input photo file
    $photo = Read-Host "Enter the path of the photo that contains hidden files (e.g., C:\path\to\photo.jpg)"
    $photo = "`"$photo`""

    # Get the directory and filename without extension
    $directory = [System.IO.Path]::GetDirectoryName($photo.Trim('"'))
    $filename = [System.IO.Path]::GetFileNameWithoutExtension($photo.Trim('"'))

    # Create the new file path with .zip extension
    $newFilePath = [System.IO.Path]::Combine($directory, "$filename.zip")

    # Copy the original file to the new file with .zip extension
    Copy-Item -Path $photo.Trim('"') -Destination $newFilePath

    # Confirm completion
    Write-Host "`nThe file has been unlocked to $newFilePath.`n" -ForegroundColor Green
    pause
}

function Show-Menu {
    Clear-Host







# Function to center text
function CenterText {
    param (
        [string]$text,
        [int]$width
    )
    
    $textLength = $text.Length
    $padding = ($width - $textLength) / 2
    return (" " * [math]::Max([math]::Ceiling($padding), 0)) + $text + (" " * [math]::Max([math]::Floor($padding), 0))
}

# Function to create a border
function CreateBorder {
    param (
        [string[]]$lines,
        [int]$width
    )

    $borderLine = "+" + ("-" * $width) + "+"
    $borderedText = @($borderLine)
    foreach ($line in $lines) {
        $borderedText += "|$(CenterText $line $width)|"
    }
    $borderedText += $borderLine
    return $borderedText -join "`n"
}

# Display script information with border
$title = "Zipography Privacy Tool v1.0"
$copyright = "Copyright 2024 Magdy Aloxory. All rights reserved."
$contact = "Contact: maloxory@gmail.com"
$maxWidth = 60

$infoText = @($title, $copyright, $contact)
$borderedInfo = CreateBorder -lines $infoText -width $maxWidth

Write-Host $borderedInfo -ForegroundColor Cyan







    Write-Host "Select an option:"
    Write-Host "1. Hide zip file inside a photo"
    Write-Host "2. Unhide zip file from a photo"
    Write-Host "3. Exit"
}

do {
    Show-Menu
    $choice = Read-Host "Enter your choice (1-3)"

    switch ($choice) {
        1 { Hide-ZipInPhoto }
        2 { Unhide-ZipFromPhoto }
        3 { Write-Host "Exiting..."; exit }
        default { Write-Host "Invalid choice. Please enter 1, 2, or 3."; pause }
    }
} while ($true)
