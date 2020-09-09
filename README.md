# photo_sh
Collection of photography shell scripts

## Photo editing process
 1. On camera:
    * Delete clearly bad pictures (blur or bad composition)
 2. On a Mac:
    * Move pictures from memory card on computer, into date-based directories "`YYMMDD_Name_of_event`" (one for each day)
    * Move pictures from other cameras (and phones) into the aforementioned directories
      * NOTE: if the devices have mismatched time or date, use `exiftool` to correct them first
 3. Inside every directory:
    * Sort by type and move all RAW files into a subdirectory called "RAW" (this will get slow RAW files out of the way)
    * Delete bad ones using `Space` and navigating with the arrow keys. `Option+Space` can help in comparing sharpness (`Option` zooms 100%, but deleting individual images is not possible in this mode)
      * NOTE: series of pictures to be used for panoramas or stacks are to be put into a subdirectory called `XXXX_optional_name`, where "XXXX" is the name of the first picture. That way, the directory will sort just below the outcome of the panorama, which will be stored in the parent directory. More on panoramas below. 
    * `cd` to the "RAW" directory and execute `rawmatch.sh` to delete all RAW files whose corresponding JPG has been deleted
    * Move remaining RAW files up one directory and delete the RAW directory
    * Sort by name, `Command+A+Right_arrow` and put panorama RAW files into their corresponding folders. `FIXME: a script should do this`
 4. Darktable:
    * Move all panorama directories into a `panoramas` subdirectory
    * In Darktable, Import > Folder... > Select the "`panoramas`" subdirectory > Import options > Select "`import directories recursively`" and "`Ignore JPEG files`"
    * Click on the [G] button in the upper-right corner of the interface to group JPG-RAW pairs. This works nicely with images that have no corresponding RAW file

## Panoramas: Hugin
1. Create quick panorama to see if the images stitch well
   * Drag and drop the series of images into `Hugin`
   * Click on "Preview panorama (OpenGL)" button
   * Click on "Align"
   * Make manual adjustments using Move/Drag and Crop
   * Click on "Create Panorama..."
   * Save as jpg

2. Enhance the series of images in `Darktable`
   * Open them in `Darktable`
   * Correct lens distortion, even out exposure, denoise
   * Export as TIF (16-bit)
 
3. Create panorama using the TIF exports from Darktable per step 1, but export as TIF instead

4. Move final TIF panorama in the parent directory. It will be enhanced in Darktable along with the other files at the end

## Stacks: align_image_stack + Hugin

Convert RAW to TIF:

    mogrify -format TIF *.JPG
    
Align series of images:

    cd ~/Pictures/YYMMDD_Location/RAW/_XXXXX/
    /Applications/Hugin/tools_mac/align_image_stack -m -a OUTPREFIX -vv *.RW2

Apply median stacking:

    magick convert OUTPREFIX* -evaluate-sequence median outmedianstacked.jpg

## exiftool

#### Transfer tag dates from one image to the other (panoramas)
`exiftool -TagsFromFile P1510184.MP4 -FileModifyDate panorama.jpg`
https://photo.stackexchange.com/questions/89442/how-to-copy-datetaken-tag-from-another-image-using-exiftool

#### Batch transfer exif tag from one file to another

`exiftool -TagsFromFile ../%f.jpg "-FileModifyDate<DateTimeOriginal" -ext jpg .`
https://stackoverflow.com/questions/51353428/batch-copy-metadata-from-one-file-to-another-exiftool

#### Shift AllDates (Shorthand for DateTimeOriginal, CreateDate, and ModifyDate) by 46 minutes and 8 seconds
`exiftool "-AllDates+=0:0:0 0:46:08"`

#### Display all date tags
    exiftool -a -s -G1 -time:all .

    [System]        FileModifyDate                  : 2020:05:25 10:27:02-05:00
    [System]        FileAccessDate                  : 2020:06:03 09:32:10-05:00
    [System]        FileInodeChangeDate             : 2020:06:03 09:32:10-05:00
    [QuickTime]     CreateDate                      : 2020:05:25 13:31:34
    [QuickTime]     ModifyDate                      : 2020:05:25 13:31:34
    [Track1]        TrackCreateDate                 : 2020:05:25 11:13:10
    [Track1]        TrackModifyDate                 : 2020:05:25 11:13:10
    [Track1]        MediaCreateDate                 : 2020:05:25 11:13:10
    [Track1]        MediaModifyDate                 : 2020:05:25 11:13:10
    [Track2]        TrackCreateDate                 : 2020:05:25 11:13:10
    [Track2]        TrackModifyDate                 : 2020:05:25 11:13:10
    [Track2]        MediaCreateDate                 : 2020:05:25 11:13:10
    [Track2]        MediaModifyDate                 : 2020:05:25 11:13:10
    [IFD0]          ModifyDate                      : 0000:00:00 00:00:00
    [ExifIFD]       DateTimeOriginal                : 2020:05:25 10:27:02
    [ExifIFD]       CreateDate                      : 2020:05:25 10:27:02
    [Panasonic]     TimeStamp                       : 2020:05:25 16:27:02
    [ExifIFD]       SubSecTime                      : 651
    [ExifIFD]       SubSecTimeOriginal              : 651
    [ExifIFD]       SubSecTimeDigitized             : 651
    [Composite]     SubSecCreateDate                : 2020:05:25 10:27:02.651
    [Composite]     SubSecDateTimeOriginal          : 2020:05:25 10:27:02.651
    [Composite]     SubSecModifyDate                : 0000:00:00 00:00:00.651
    
#### Apply exif date to Finder's "Date Modified" date

`exiftool '-DateTimeOriginal>FileModifyDate' .`

#### Shifting date and time on videos

That keeps the files sorted in macOS Finder, and hopefully also in other software.

    exiftool "-AllDates+=0:0:0 0:46:08" *MP4
    exiftool "-Quicktime:Time:All+=0:0:0 0:46:08" *MP4
    exiftool "-TrackCreateDate>FileModifyDate" *MP4

#### Hugin: lens data for Essential PH-1 images

    Sensor: Sony IMX258 : Diagonal 5.867 mm (Type 1/3.06)
    https://www.sony-semicon.co.jp/products/common/pdf/ProductBrief_IMX258_20151015.pdf

    HFOV: 73.85?
    Focal length: 3.4 mm
    Focal multiplier: 43.3/5.867 = 7.38
    
## Debugging Hugin:

Images are too different to be stacked:

    After control points pruning reference images has no control
    points Optimizing field of view in this case results in undefined
    behaviour. Increase error distance (-t parameter), tweak cp
    detection parameters or don't optimize HFOV.`

Solution:

Add `-x -y -z` and/or `-c 32`
