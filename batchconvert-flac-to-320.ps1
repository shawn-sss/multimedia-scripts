# Define paths
$basePath = Get-Location
$inputPath = Join-Path $basePath "input"
$outputPath = Join-Path $basePath "output"
$ffmpegPath = Join-Path $basePath "bin\ffmpeg.exe"

# Create the input and output folders if they don't exist
if (-Not (Test-Path -Path $inputPath)) {
    New-Item -ItemType Directory -Path $inputPath
}

if (-Not (Test-Path -Path $outputPath)) {
    New-Item -ItemType Directory -Path $outputPath
}

# Function to process files
function Process-Files {
    param (
        [string]$sourceDir,
        [string]$destDir
    )

    Get-ChildItem -Path $sourceDir -Recurse | ForEach-Object {
        $relativePath = $_.FullName.Substring($sourceDir.Length + 1)
        $outputFile = Join-Path $destDir $relativePath
        $outputDir = [System.IO.Path]::GetDirectoryName($outputFile)

        if (-Not (Test-Path -Path $outputDir)) {
            New-Item -ItemType Directory -Path $outputDir
        }

        if ($_.Extension -ieq ".mkv") {
            & $ffmpegPath -i $_.FullName -c:v copy -c:a aac -b:a 320k $outputFile
        } else {
            Copy-Item -Path $_.FullName -Destination $outputFile
        }
    }
}

# Run the function
Process-Files -sourceDir $inputPath -destDir $outputPath
