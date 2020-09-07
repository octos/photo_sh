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
    * Sort by type and move all RAW files into a subdirectory called "RW2" (this will get slow RAW files out of the way)
    * Delete bad ones using `Space` and navigating with the arrow keys. `Option+Space` can help in comparing sharpness (`Option` zooms 100%, but deleting individual images is not possible in this mode)
      * NOTE: series of pictures to be used for panoramas or stacks are to be put into a subdirectory called `XXXX_optional_name`, where "XXXX" is the name of the first picture. That way, the directory will sort just below the outcome of the panorama, which will be stored in the parent directory. More on panoramas below. 
    * `cd` to the "RW2" directory and execute `rawmatch.sh` to delete all RW2 files whose corresponding JPG has been deleted
    * move remaining RW2 files from 
 4. Darktable:
    * Open the "`YYMMDD_Name_of_event`" directory in Darktable
    * Click on the [G] button in the upper-right corner of the interface to group JPG-RW2 pairs. This works nicely with images that have no corresponding RAW file

## Panoramas
1. Crete quick panorama to see if the images stitch well
 * Drag and drop the series of images into `Hugin`
 * Click on Preview panorama (OpenGL)
 * Click on align
 * Make manual adjustments using Move/Drag and Crop
 * Create panorama
 * Save as jpg

2. Enhance the series of images in `Darktable`
 * Open them in `Darktable`
 * Correct lens distortion, even out exposure, denoise
 * Export as TIF (16-bit)
 
3. Create panorama using the TIF exports from Darktable per step 1, but export as TIF instead

4. Move final TIF panorama in the parent directory. It will be enhanced in Darktable along with the other files at the end

## Stacks
TBC
