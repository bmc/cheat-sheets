% Thunderbird Cheat Sheet


## Script busy or not responding

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

## Adjusting fonts in the entire program:

Add this entry to `userChrome.css` (in
`~/.thunderbird/whatever.default/chrome/userChrome.css`):

    * {
       font-size: 20pt !important
    }

## HTML message issues

* Thunderbird insists on sending HTML (e.g., on a reply to an HTML
  message), even though the Compose HTML general setting is off, and even
  though HTML is disabled for the recipient.
  **Solution**: Check the HTML setting associated with the identity (in Manage
  Identities).

## Thunderbird crashes on previously created local folders directory.

Remove all `*.msf` files.
