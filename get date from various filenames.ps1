

$i=0
$MediaFolder = "C:\Users\Tor\Downloads\immich-20240923_201559-10-sep\New folder"
$ExifToolLocation = "C:\Users\Tor\Downloads\immich-20240923_201559-10-sep\exiftool.exe"
Get-ChildItem $MediaFolder | Unblock-File
$MyFiles = Get-ChildItem -Path $MediaFolder -File –Recurse -Exclude *.json,*.db,*.ps1,*.mp4_exiftool_tmp

#Normal date format detecting regex:
$regex1 = '(?<filedate1>[0-3]\d{3}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2})[^0-9]'

#Unix timestamp date format detecting regex:
$regex2 = '(?<filedate2>[0-2]\d{8}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2})[^0-9]'

#Next level of regex is trying to find if there is a clock time after the date
$regex3 = '(?<clocktime1>[0-2]\d(?:\.|-|_)?[0-5]\d(?:\.|-|_)?[0-5]\d)'

#Next level of regex is trying to find if there is a clock time after the date
$regex4 = '(?<clocktime2>[0-2]?[0-9][0-3][0-5][0-9])'
#^([0-1]?[0-9]|2[0-3]):[0-5][0-9]$

$MyFiles | ForEach-Object {
    $MyFullName = $_.FullName
    $MyName = $_.Name
    If ($MyName -match $regex1) {
        $MyMatch = $Matches['filedate1']
        $date = ($Matches['filedate1'] -replace '(\.|-|_)','')
        try {
            $dateFromFileName = [datetime]::ParseExact($date,'yyyyMMdd',[cultureinfo]::InvariantCulture)
            $MyName = $MyName.Replace($MyMatch,'')
            If ($MyName -match $regex3) {
                $clocktime = ($Matches['clocktime1'] -replace '(\.|-|_)','')
                try {
                    $dateFromFileName = $dateFromFileName.AddHours($clocktime.Substring(0,2))
                    $dateFromFileName = $dateFromFileName.AddMinutes($clocktime.Substring(2,2))
                    $dateFromFileName = $dateFromFileName.AddSeconds($clocktime.Substring(4,2))
                    #Correcting timeclock if found
                    $dateString = $dateFromFileName.tostring("yyyy/MM/dd HH:mm:ss")
                }catch {}
            }
            ElseIf ($MyName -match $regex4) {
            $clocktime = ($Matches['clocktime2'] -replace '')
                try {
                    $dateFromFileName = $dateFromFileName.AddHours($clocktime.Substring(0,2))
                    $dateFromFileName = $dateFromFileName.AddMinutes($clocktime.Substring(2,2))
                    $dateFromFileName = $dateFromFileName.AddSeconds(00)
                    #Correcting timeclock if found
                    $dateString = $dateFromFileName.tostring("yyyy/MM/dd HH:mm:ss")
                }catch {}
            }

            $arguments = " ""-CreateDate='$dateString'"" ""-DateTimeOriginal='$dateString'"" -overwrite_original ""$MyFullName"""
            "$ExifToolLocation $arguments"
            Start-Process -FilePath $ExifToolLocation -Wait -NoNewWindow -ArgumentList $arguments
            $i++
        } catch {}
    } ElseIf ($MyName -match $regex2) {
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


