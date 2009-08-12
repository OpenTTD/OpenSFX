OpenSFX README
Last updated:    2009-08-12
Release version: 0.1-alpha1
------------------------------------------------------------------------

Table of Contents:
------------------
1.0) About OpenSFX
 * 1.1) License
2.0) Installing OpenSFX
 * 2.1) Installing OpenSFX manually
 * 2.2) Installing OpenSFX using the Online Content service
3.0) Obtaining the source
 * 3.1) Compiling the source
 * 3.2) Contributing
4.0) Credits


1.0) About OpenSFX
==== =============
OpenSFX is a set of base sounds for OpenTTD and is the result of the
"Sound Effects Replacement" project.

OpenSFX is an open source replacement for the original TTD (Transport
Tycoon Deluxe) base sounds used by OpenTTD. The main goal of OpenSFX
therefore is to provide a set of free sounds which make it possible to
play OpenTTD without requiring the (copyrighted) files from the TTD cd.
This potentially increases the OpenTTD fanbase and makes it a true
free game (with "free" as in both "free beer" and "open source").

1.1) License
==== =======
OpenSFX is licensed under the Creative Commons Sampling Plus 1.0 License.
You can find the full text in license.txt.


2.0) Installing
==== ==========
OpenSFX is available from at least three locations. This readme will
only cover the official download locations. We cannot support third
party download locations and we cannot refund your money if you have
paid money for OpenSFX.

There's two places where you can get the latest stable release:
  * If you're new to OpenTTD and don't have access to the original
    TTD files, you'll have to download and install OpenSFX manually.
    This is really not that difficult as it may sound, so don't
    worry too much about that.
      o Download location:
          http://mz.openttdcoop.org/bundles/opensfx/releases/
      o Installation instructions:
          Installing OpenSFX Manually.

  * If you already have OpenTTD up and running using the original
    TTD base graphics, the ingame Online Content service is the easy
    way to obtain OpenSFX.
      o Download location:
          use the ingame Online content service
      o Installation instructions:
          Installing OpenSFX using the Online Content service.

  * Just like OpenTTD, there are nightly builds of OpenSFX available
    as well. Every evening around 18:18 CE(S)T a new build of OpenSFX
    is created automatically (if there's something new that is).
    Unlike stable releases these builds aren't tested to see if they
    work, but if a nightly doesn't work, it doesn't break anything
    either. Keep a stable or working nightly sitting in the /data dir
    and just delete a broken nightly to get OpenSFX working again.
      o Download location:
          http://mz.openttdcoop.org/bundles/opensfx/nightlies/
      o Installation instructions:
          Installing OpenSFX Manually.

2.1) Installing OpenSFX Manually
==== ===========================
1. First, make sure that you've downloaded and installed at least
   OpenTTD version 0.8.0 or a recent nightly.
2. Next, download the latest OpenSFX package. (stable nightly)
3. Unpack the zip into the OpenTTD's /data directory. There's no
   need to unpack the tar file, so just leave it as it is. Your
   OpenTTD /data directory is either located in:
     * An OpenTTD folder in your user account's home directory:
          o Windows: C:\Documents and Settings\<username>\My Documents\OpenTTD
          o Mac OSX: ~/Documents/OpenTTD
          o Linux: ~/.openttd
     * The OpenTTD installation directory.
4. Run OpenTTD.
5. In the main menu of the game, click the Game Options button.
   The Game Options dialog will appear.
6. Select OpenSFX from the drop-down list below Base sound set if
   that's not selected already (bottom left of window). Close the
   window using the × in the upper left corner.
     * If you did not install the original TTD base sounds during
       the installation of OpenTTD, you can skip this step.
     * If you installed the original TTD base sounds as well, this
       is where you can switch base sound sets.

2.2) Installing or Updating OpenSFX using the Online Content service
==== ===============================================================
This method uses the Online content service (BaNaNaS) to download OpenSFX.
In order to use this, you need a working OpenTTD and again at least
OpenTTD version 0.8.0 or a recent nightly.

1. Start OpenTTD and on the main menu click the Check online content
   button. A new window will pop up.
     * If OpenTTD doesn't start, follow the manual installation procedure.
2. Find the OpenSFX entry from the list at the left. You can use the
   search box in the upper right corner of the window.
3. Click the little square in front of the OpenSFX entry in order to
   mark it for download.
4. Click the Download button in the bottom right corner. After
   download, close the open windows.
5. In the main menu of the game, click the Game Options button. The Game
   Options dialog will appear.
6. Select OpenSFX from the drop-down list below Base sound set if
   that's not selected already (bottom left of window). Close the
   window using the × in the upper left corner.
     * This is where you can switch base sound sets.


3.0) Obtaining the source
==== ====================
The OpenSFX source is available in a Mercurial repository. You can
download the source in bz2, zip or gz format from:
> http://mz.openttdcoop.org/hg/opensfx
You can use Mercurial to do an anonymous checkout from the same address:
> hg clone http://mz.openttdcoop.org/hg/opensfx

3.1) Compiling the source
==== ====================
For compiling the source you need:
 * catcodec (http://www.openttd.org/download-catcodec)
 * (GNU) make
 * md5sum
 * cut
 * a sh compatible shell
 * hg (Mercurial) if you want it to be properly versioned
If you want to package you also need tar, zip and possibly bzip2.

3.2) Contributing
==== ============
Contributing to OpenSFX can be done in several ways, but they generally end
up with providing (improved) samples for the set. If you've got a better
sample than we currently have you can make that know via an issue at:
> http://dev.openttdcoop.org/projects/opensfx/issues/new
Please mention who made the original samples and that the sample has been
released under the Creative Commons Sampling Plus 1.0 License or a license
that allows us to release it under that license.


4.0) Credits
==== =======
The original sources of our mixed samples are:
 - "acclivity" from "freesound.org"
 - "Aldor" from "pdsounds.org"
 - "alexrigg" from "freesound.org"
 - "Anton" from "freesound.org"
 - "Benboncan" from "freesound.org"
 - "Bidone" from "freesound.org"
 - "conny" from "freesound.org"
 - "dobroide" from "freesound.org"
 - Elaine Miller ("Miselaineous" at "freesound.org")
 - "Halleck" from "freesound.org"
 - "han1" from "freesound.org"
 - Janis Lukss ("Pendrokar" at "wiki.openttd.org")
 - Jillian Callahan ("JillianCallahan" at "freesound.org")
 - "krillion" from "freesound.org"
 - "Leady" from "freesound.org"
 - Leon Milo ("milo" at "freesound.org")
 - "Marec" from "freesound.org"
 - "lorenzosu" from "freesound.org"
 - "patchen" from "freesound.org"
 - Remko Bijker ("Rubidium" at "wiki.openttd.org")
 - Robert Gacek ("Robinhood76" at "freesound.org")
 - "roscoetoon" from "freesound.org"
 - "sagetyrtle" from "freesound.org"
 - "saphix" from "freesound.org"
 - "tigersound" from "freesound.org"
 - Tom Haigh ("audible-edge" from "freesound.org")

Editing/(re)mixing was done by:
 - Janis Lukss ("Pendrokar" at "wiki.openttd.org")
 - "Jklamo" from "wiki.opentd.org"
 - Remko Bijker ("Rubidium" at "wiki.openttd.org")

A detailed list of who has worked on what sample is available in the
file opensfx.sfo in the source repository.

Thanks go out to the guys at #openttdcoop for providing the source
repository and bug tracking services.
