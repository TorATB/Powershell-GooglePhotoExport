
$MediaFolder = "D:\Backup\Cloud\Exported Google Photos - 2022.06.15"
$MyFiles = Get-ChildItem -Path $MediaFolder -File –Recurse -Exclude *.json,*.db,*.ps1,*.mp4_exiftool_tmp

#Normal date format detecting regex:
$regex1 = '(?<filedate1>[0-3]\d{3}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2})[^0-9]'

#Unix timestamp date format detecting regex:
$regex2 = '(?<filedate2>[0-2]\d{8}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2})[^0-9]'

function Get-GoogleDateFormat {
    param (
        $InDate
    )
    $MyMonth = (get-date $InDate -Format Y).ToString()
    $MyMonth = $MyMonth.Substring(0, [Math]::Min($MyMonth.Length, 3))
    $MyDate = Get-Date $InDate -Format "dd, yyyy, HH:mm:ss"
    $MyDate = "$MyMonth $MyDate PM UTC"
    $MyDate
}

$i=0
$MyFilesCount = $MyFiles.count
$MyFiles | ForEach-Object {
    "["+$i+"/"+$MyFilesCount+"]"
    $MyFullName = $_.FullName
    $MyName = $_.Name
    If ($_.Name -match $regex1) {
        $date = ($Matches['filedate1'] -replace '(\.|-|_)','')
        try {
            $dateFromFileName = [datetime]::ParseExact($date,'yyyyMMdd',[cultureinfo]::InvariantCulture)
            $timestampFromFileName = Get-Date -Date $dateFromFileName -UFormat %s
            $dateFromFileNameString = $dateFromFileName.tostring("yyyy:MM:dd HH:mm:ss")

            if (Test-Path -Path "$MyFullName.json" -PathType Leaf) {
                $json = Get-Content "$MyFullName.json"  -encoding utf8 | ConvertFrom-Json
                $dateFromJson=(Get-Date 01.01.1970)+([System.TimeSpan]::fromseconds($json.photoTakenTime.Timestamp))
                $timestampFromJson = Get-Date -Date $dateFromJson -UFormat %s

                #Next level of regex is trying to find if there is a clock time after the date
                $regex3 = '(?<clocktime>[0-2]\d(?:\.|-|_)?[0-5]\d(?:\.|-|_)?[0-5]\d)'
                $MyName = $MyName.Replace($date,'')

                If ($MyName -match $regex3) {
                    $clocktime = ($Matches['clocktime'] -replace '(\.|-|_)','')
                    try {
                        $dateFromFileName = $dateFromFileName.AddHours($clocktime.Substring(0,2))
                        $dateFromFileName = $dateFromFileName.AddMinutes($clocktime.Substring(2,2))
                        $dateFromFileName = $dateFromFileName.AddSeconds($clocktime.Substring(4,2))
                        #Correcting timeclock if found
                        $dateFromFileNameString = $dateFromFileName.tostring("yyyy:MM:dd HH:mm:ss")
                    }catch {}
                }

                if ((($dateFromJson - $dateFromFileName).Days) -ne 0) {
                    $json.photoTakenTime.formatted = Get-GoogleDateFormat $dateFromFileName
                    $json.photoTakenTime.timestamp = $timestampFromFileName
                    $json.creationTime.formatted = Get-GoogleDateFormat $dateFromFileName
                    $json.creationTime.timestamp = $timestampFromFileName

                    #save json-file
                    write-host "Updating jsonfile with correct date : $MyFullName"
                    write-host "Date found from file : $dateFromFileNameString"
                    $json | convertto-json | set-content "$MyFullName.json" -encoding utf8
                }
            }
            
        }catch {}
    } ElseIf ($_.Name -match $regex2) {
        $date = ($Matches['filedate2'] -replace '(\.|-|_)','').subString(0, 10)
        try {
            $timestampFromFileName = $date
            $dateFromFileName = (Get-Date 01.01.1970)+([System.TimeSpan]::fromseconds($date))
            $dateFromFileNameString = $dateFromFileName.tostring("yyyy:MM:dd HH:mm:ss")

            if (Test-Path -Path "$MyFullName.json" -PathType Leaf) {
                $json = Get-Content "$MyFullName.json"  -encoding utf8 | ConvertFrom-Json
                $dateFromJson=(Get-Date 01.01.1970)+([System.TimeSpan]::fromseconds($json.photoTakenTime.Timestamp))
                $timestampFromJson = Get-Date -Date $dateFromJson -UFormat %s

                if ((($dateFromJson - $dateFromFileName).Days) -ne 0) {
                    $json.photoTakenTime.formatted = Get-GoogleDateFormat $dateFromFileName
                    $json.photoTakenTime.timestamp = $timestampFromFileName
                    $json.creationTime.formatted = Get-GoogleDateFormat $dateFromFileName
                    $json.creationTime.timestamp = $timestampFromFileName

                    #save json-file
                    write-host "Updating jsonfile with correct date : $MyFullName"
                    write-host "Timestamp converted  : $dateFromFileNameString"
                    $json | convertto-json | set-content "$MyFullName.json" -encoding utf8
                }
            }
        }catch {}
    }
    $i++
}


