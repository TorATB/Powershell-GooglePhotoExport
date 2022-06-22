
$MediaFolder = "D:\Backup\Cloud\Exported Google Photos - 2022.06.15"
$MyFiles = Get-ChildItem -Path $MediaFolder -File –Recurse -Exclude *.json,*.db,*.ps1,*.mp4_exiftool_tmp

#Normal date format detecting regex:
$regex1 = '(?<filedate1>\d{4}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2})[^0-9]'

#Unix timestamp date format detecting regex:
$regex2 = '(?<filedate2>[0-2]\d{8}(?:\.|-|_)?\d{2}(?:\.|-|_)?\d{2})[^0-9]'

function Get-GoogleDateFormat {
    param (
        $InDate
    )
    $MyMonth = (get-date $InDate -Format Y).ToString()
    $MyMonth = $MyDate.Substring(0, [Math]::Min($MyDate.Length, 3))
    $MyDate = Get-Date $InDate -Format "dd, yyyy, HH:mm:ss"
    $MyDate = "$MyMonth $MyDate PM UTC"
    $MyDate
}

$MyFiles | ForEach-Object {
    $MyFullName = $_.FullName
    If ($_.Name -match $regex1) {
        $date = ($Matches['filedate1'] -replace '(\.|-|_)','')
        try {
            $dateFromFileName = [datetime]::ParseExact($date,'yyyyMMddHHmmss',[cultureinfo]::InvariantCulture)
            $timestampFromFileName = Get-Date -Date $dateFromFileName -UFormat %s
            $dateFromFileNameString = $dateFromFileName.tostring("yyyy:MM:dd HH:mm:ss")
            
            $json = Get-Content "$MyFullName.json"  -encoding utf8 | ConvertFrom-Json
            $dateFromJson=(Get-Date 01.01.1970)+([System.TimeSpan]::fromseconds($json.photoTakenTime.Timestamp))
            $timestampFromJson = Get-Date -Date $dateFromJson -UFormat %s

            if ((($dateFromJson - $dateFromFileName).Days) -gt 0) {
                write-host "Found wrong date in json-file, setting correct date in $MyFullName.json"
                $json.photoTakenTime.formatted = Get-GoogleDateFormat $dateFromFileName
                $json.photoTakenTime.timestamp = $timestampFromFileName
                $json.creationTime.formatted = Get-GoogleDateFormat $dateFromFileName
                $json.creationTime.timestamp = $timestampFromFileName

                #save json-file
                $json | convertto-json | set-content "$MyFullName.json" -encoding utf8
            }
        }catch {}
    } ElseIf ($_.Name -match $regex2) {
        $date = ($Matches['filedate2'] -replace '(\.|-|_)','').subString(0, 10)
        try {
            $timestampFromFileName = $date
            $dateFromFileName = (Get-Date 01.01.1970)+([System.TimeSpan]::fromseconds($date))
            $dateFromFileNameString = $dateFromFileName.tostring("yyyy:MM:dd HH:mm:ss")
            
            $json = Get-Content "$MyFullName.json"  -encoding utf8 | ConvertFrom-Json
            $dateFromJson=(Get-Date 01.01.1970)+([System.TimeSpan]::fromseconds($json.photoTakenTime.Timestamp))
            $timestampFromJson = Get-Date -Date $dateFromJson -UFormat %s

            if ((($dateFromJson - $dateFromFileName).Days) -gt 0) {
                write-host "Found wrong date in json-file, setting correct date in $MyFullName.json"
                $json.photoTakenTime.formatted = Get-GoogleDateFormat $dateFromFileName
                $json.photoTakenTime.timestamp = $timestampFromFileName
                $json.creationTime.formatted = Get-GoogleDateFormat $dateFromFileName
                $json.creationTime.timestamp = $timestampFromFileName

                #save json-file
                $json | convertto-json | set-content "$MyFullName.json" -encoding utf8
            }
        }catch {}
    }
}
