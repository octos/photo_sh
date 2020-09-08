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

## Panoramas
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

## Stacks

Convert RAW to TIF:

    mogrify -format TIF *.JPG
    
Align series of images:

    cd ~/Pictures/YYMMDD_Location/RAW/_XXXXX/
    /Applications/Hugin/tools_mac/align_image_stack -m -a OUTPREFIX -vv *.RW2

Apply median stacking:

    magick convert OUTPREFIX* -evaluate-sequence median outmedianstacked.jpg
    
### Debugging:

Images are too different to be stacked:

    After control points pruning reference images has no control
    points Optimizing field of view in this case results in undefined
    behaviour. Increase error distance (-t parameter), tweak cp
    detection parameters or don't optimize HFOV.`

Solution:

Add `-x -y -z` and/or `-c 32`
