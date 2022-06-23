﻿
$i=0
$MediaFolder = "D:\Backup\Cloud\Xiaomi 12 Pro 2022\Screenshots"
$ExifToolLocation = "C:\Program Files\exiftool-12.42\exiftool.exe"
$MyFiles = Get-ChildItem -Path $MediaFolder -File –Recurse -Exclude *.json,*.db,*.ps1,*.mp4_exiftool_tmp

#Normal date format detecting regex:
$regex1 = '(?<filedate1>[0-3]\d{3}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2})[^0-9]'

#Unix timestamp date format detecting regex:
$regex2 = '(?<filedate2>[0-2]\d{8}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2})[^0-9]'

$MyFiles | ForEach-Object {
    $MyFullName = $_.FullName
    $MyName = $_.Name
    If ($MyName -match $regex1) {
        $date = ($Matches['filedate1'] -replace '(\.|-|_)','')
        try {
            $dateString = $dateFromFileName.tostring("yyyy:MM:dd")

            #Next level of regex is trying to find if there is a clock time after the date
            $regex3 = '(?<clocktime>[0-2]\d(?:\.|-|_)?[0-5]\d(?:\.|-|_)?[0-5]\d)'
            $MyName = $MyName.Replace($dateString,'')

            If ($MyName -match $regex3) {
                $clocktime = ($Matches['clocktime'] -replace '(\.|-|_)','')
                try {
                    $dateFromFileName = $dateFromFileName.AddHours($clocktime.Substring(0,2))
                    $dateFromFileName = $dateFromFileName.AddMinutes($clocktime.Substring(2,2))
                    $dateFromFileName = $dateFromFileName.AddSeconds($clocktime.Substring(4,2))
                    #Correcting timeclock if found
                    $dateString = $dateFromFileName.tostring("yyyy:MM:dd HH:mm:ss")
                }catch {}
            }

            $date = $dateFromFileName
            $dateString = $dateFromFileName.tostring("yyyy:MM:dd HH:mm:ss")


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
