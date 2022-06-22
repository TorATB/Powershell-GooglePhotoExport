# Powershell-GooglePhotoExport
After you export your mediafiles from Google Photo, you usually have to fix alot of issues with dates and other information. You can use Powershell and exiftool to make the job easier.
Here are some scripts that I made so you might have an easier job than me.

********************************************
**** "get date from various filenames.ps1"
****

This powershell script requires exiftool.exe, you can download it here:
https://exiftool.org/ (you might need to rename the exe-file)

It will set the correct date directly in the file, using exiftool

Here is a list of filenames that I tested on and it fould all the names containing the dates!
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