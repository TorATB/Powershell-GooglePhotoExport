# Powershell-GooglePhotoExport

## Reminder, always work on a copy of your media-files! Don't touch the original files without a backup...

After you export your mediafiles from Google Photo, you usually have to fix alot of issues with dates and other information. You can use Powershell and exiftool to make the job easier.
Here are some scripts that I made so you might have an easier job than me.

## Powershell:  "get date from filename and update correct info in json file.ps1"


You can use this script to set the correct date in the json file from the Google Photos export.<br>
33000 files takes about 2 minutes to run.

You need to edit the ps1 file and change your media folder (It's at the top of the script).

Credit to [cduff](https://community.spiceworks.com/people/craigduff) at [spiceworks.com](https://community.spiceworks.com/topic/1869414-find-date-in-a-file-name-and-split-it-off) (I used some of his code)

...

After you have run that fix, you can run a CMD prompt (as Administrator) to put all the json information directly in your media files.
The command requires exiftool.exe, you can download it here:
https://exiftool.org/ (you might need to rename the exe-file)

Here is that command: (you need to change this path, c:\MyExampleMediaFolder)

This command will put all the google photo information directly in your mediafiles.
```
exiftool -r -d %s -tagsfromfile "%d/%F.json" "-GPSAltitude<GeoDataAltitude" "-GPSLatitude<GeoDataLatitude" "-GPSLatitudeRef<GeoDataLatitude" "-GPSLongitude<GeoDataLongitude" "-GPSLongitudeRef<GeoDataLongitude" "-Keywords<PeopleName" "-Subject<PeopleName" "-Caption-Abstract<Description" "-ImageDescription<Description" "-DateTimeOriginal<PhotoTakenTimeTimestamp" "-FileCreateDate<PhotoTakenTimeTimestamp" -ext "*" -overwrite_original -progress --ext json "c:\MyExampleMediaFolder"
```
33000 files takes about 60 minutes to run.

If you don't want people information in your media files (privacy protection), here is the same command without that part.
```
exiftool -r -d %s -tagsfromfile "%d/%F.json" "-GPSAltitude<GeoDataAltitude" "-GPSLatitude<GeoDataLatitude" "-GPSLatitudeRef<GeoDataLatitude" "-GPSLongitude<GeoDataLongitude" "-GPSLongitudeRef<GeoDataLongitude" "-Caption-Abstract<Description" "-ImageDescription<Description" "-DateTimeOriginal<PhotoTakenTimeTimestamp" "-FileCreateDate<PhotoTakenTimeTimestamp" -ext "*" -overwrite_original -progress --ext json "c:\MyExampleMediaFolder"
```
33000 files takes about 60 minutes to run.


## Powershell:  "get date from various filenames.ps1"


You can use this script to set the correct date directly in the media files, using exiftool, no json file involved

This powershell script requires exiftool.exe, you can download it here:
https://exiftool.org/ (you might need to rename the exe-file)

You need to edit the ps1 file and change your media folder and your exiftool location (They are both at the top of the script).

Here is a list of filenames that I tested on and it fould all the names containing the dates!
```
20171006_124006.jpg
20171006_162657.jpg
20171006_183337(0).jpg
20191130_111231.jpg
20191130_111231-1.jpg
20191130_111245.jpg
20211201_125933.mp4
475777329560_imgur_2018-03-05_13-11-10_iwxe1ir.jpeg
475777358220_redd_2018-03-05_13-10-41_graf3ttc.jpeg
Cat is Shocked________-20210614193350.mp4
FB_IMG_1579878940239.jpg
FB_IMG_1579878950558.jpg
FB_IMG_1581453535406.jpg
IMG_20191031_163213.jpg
IMG_20191031_163220.jpg
IMG_20200110_081932.jpg
received_369931738324578.jpeg  <==== Did not detect, since this is not a date (as far as I know)
Screenshot_2022-04-28-11-26-55-097_org.thoughtcrime.securesms.jpg
Screenshot_2022-05-03-13-09-15-226_com.getmonument.android.jpg
Screenshot_2022-05-16-09-13-40-075_com.getmonument.android.jpg
VID_20210628_141514.mp4
VID_20210704_104414.mp4
VID_20210704_105134.mp4
```
33000 files takes about 60 minutes to run.
