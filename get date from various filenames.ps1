
$i=0
$MediaFolder = "C:\Temp\test3\date"
$ExifToolLocation = "C:\Temp\exiftool-12.42\exiftool.exe"
$MyFiles = Get-ChildItem -Path $MediaFolder -File –Recurse -Exclude *.json,*.db,*.ps1,*.mp4_exiftool_tmp

#Normal date format detecting regex:
$regex1 = '(?<filedate1>\d{4}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2})[^0-9]'

#Unix timestamp date format detecting regex:
$regex2 = '(?<filedate2>[0-2]\d{8}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2})[^0-9]'

$MyFiles | ForEach-Object {
    $MyFullName = $_.FullName
    If ($_.Name -match $regex1) {
        $date = ($Matches['filedate1'] -replace '(\.|-|_)','')
        try {
            $date = [datetime]::ParseExact($date,'yyyyMMddHHmmss',[cultureinfo]::InvariantCulture)
            $dateString = $date.ToString()


            $arguments = " ""-CreateDate='$dateString'"" ""-DateTimeOriginal='$dateString'"" -overwrite_original ""$MyFullName"""
            "$ExifToolLocation $arguments"
            Start-Process -FilePath $ExifToolLocation -Wait -NoNewWindow -ArgumentList $arguments
            $i++
        } catch {}
    } ElseIf ($_.Name -match $regex2) {
        $date = ($Matches['filedate2'] -replace '(\.|-|_)','').subString(0, 10)
        try {
            $date = (Get-Date 01.01.1970)+([System.TimeSpan]::fromseconds($date))
            $dateString = $date.ToString()


            $arguments = " ""-CreateDate='$dateString'"" ""-DateTimeOriginal='$dateString'"" -overwrite_original ""$MyFullName"""
            "$ExifToolLocation $arguments"
            Start-Process -FilePath $ExifToolLocation -Wait -NoNewWindow -ArgumentList $arguments
            $i++
        } catch {}
    }
}
$i
