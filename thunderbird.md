---
title: Thunderbird Cheat Sheet
layout: cheat-sheet
---

# Force Thunderbird to Expunge Messages When They're Deleted

When you delete a message in your inbox (or, any folder), it's marked deleted,
but not actually deleted until the folder is compacted. This can be annoying
with an IMAP folder (e.g., one's Inbox), when it's being accessed on multiple
devices.

One solution: Set the "expunge" threshold to 1, forcing Thunderbird to expunge
the folder when there is 1 deleted message in it. (The default is 20.)

Use the advanced configuration editor, and set
**mail.imap.expunge_threshold_number** to 1.

See also: <http://kb.mozillazine.org/Deleting_messages_in_IMAP_accounts>

# Script busy or not responding

See <http://kb.mozillazine.org/Script_busy_or_stopped_responding>:

> If you get a "A script on this page may be busy, or it may have stopped
> responding. You can stop the script now, or you can continue to see if
> the script will complete" error message that typically means that some
> javascript didn't execute within the time specified by
> dom.max_script_run_time. This might occur when sending a message using a
> mailing list or when fetching new mail using the webmail extension.
>
> The `dom.max_script_run_time` preference defaults to 5 seconds in
> Thunderbird 1.5. Try increasing it to 30 seconds using
> *Edit > Preferences > Advanced > General > Config* editor.

# Adjusting fonts in the entire program:

Add this entry to `userChrome.css` (in
`~/.thunderbird/whatever.default/chrome/userChrome.css`):

    * {
       font-size: 20pt !important
    }

# HTML message issues

* Thunderbird insists on sending HTML (e.g., on a reply to an HTML
  message), even though the Compose HTML general setting is off, and even
  though HTML is disabled for the recipient.
  **Solution**: Check the HTML setting associated with the identity (in Manage
  Identities).

# Thunderbird crashes on previously created local folders directory.

Remove all `*.msf` files.
