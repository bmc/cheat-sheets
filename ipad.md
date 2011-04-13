---
title: iPad Cheat Sheet
layout: cheat-sheet
---

# Email and SSL

## Self-signed certs

Using a self-signed cert will prevent the iPad from connecting, unless
the cert is loaded into the iPad. Solution: Copy the PEM file to a
browser-accessible place, then surf to it: e.g.:

    http://www.example.com/tmp/mycert.pem

The iPad will then allow installation of the certificate. Once it's installed,
Mail should work.

# Synchronizing

Connect the iPad, select it in iTunes, and click the "Info" tab. For more
info, see <http://support.apple.com/kb/ht1386>.

# The UDID (Unique Device ID)

Courtesy of <http://bjango.com/help/iphoneudid/>:

Every iPhone, iPod touch and iPad has a unique identifier number
associated with it, known as a UDID (Unique Device ID). Your UDID
is a 40-digit sequence of letters and numbers that looks something like this:
0e83ff56a12a9cf0c7290cbb08ab6752181fb54b.

It's common for developers to ask for your UDID, as they require it to
give you beta copies of iOS apps.

Finding your UDID using iTunes:

* Open iTunes (the Mac or PC app, not iTunes on your iPhone).
* Plug in your iPhone, iPod touch or iPad.
* Click its name under the devices list.
* Ensure you're on the Summary tab.
* Click on the text that says Serial Number. It should change to say
  Identifier (UDID).
* Select Copy from the Edit menu.

Your UDID is now in the clipboard, so you can paste it into an email or message.

# Side-loading .mobi Files to the Kindle App

* Load <http://www.macroplant.com/iphoneexplorer/> on the Mac. This app
  allows one to explore the iPad as if it were a USB drive.
* Using that app, open the iPad. You'll see an Apps folder and a Media
  folder.
* In the Apps folder is a Kindle folder. Go to Apps/Kindle/Library/eBooks

NOTE: This doesn't always work. If it doesn't, it's often easier to convert
the .mobi file to an ePub file. Use the Calibre application (an open source
Python GUI-based application), in that case:

* Open the .mobi file in Calibre.
* Click the "Convert eBooks" button.
* If necessary, select the MOBI input format and EPUB output format.
* Drag the resulting ePub file to the iPad, via iTunes.
