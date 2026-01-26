function Get-ApprovedVerbs {
    
    $ApprovedVerbs = `
    
    @(
    #========== COMMON ===============================================================
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Add'
            PairedWith      = 'Remove'
            Action          = 'Adds a resource to a container, or attaches an item to another item. For example, the Add-Content cmdlet adds content to a file.'
            SynonymsToAvoid = 'Append;Attach;Concatenate;Insert'
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Clear'
            PairedWith      = ''
            Action          = "Removes all the resources from a container but doesn't delete the container. For example, the Clear-Content cmdlet removes the contents of a file but doesn't delete the file."
            SynonymsToAvoid = 'Flush;Erase;Release;Unmark;Unset;Nullify'
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Close'
            PairedWith      = 'Open'
            Action          = 'Changes the state of a resource to make it inaccessible, unavailable, or unusable.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Copy'
            PairedWith      = ''
            Action          = 'Copies a resource to another name or to another container. For example, the Copy-Item cmdlet copies an item (such as a file) from one location in the data store to another location.'
            SynonymsToAvoid = 'Duplicate;Clone;Replicate;Sync'
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Enter'
            PairedWith      = 'Exit'
            Action          = 'Specifies an action that allows the user to move into a resource. For example, the Enter-PSSession cmdlet places the user in an interactive session.'
            SynonymsToAvoid = 'Push;Into'
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Exit'
            PairedWith      = 'Enter'
            Action          = 'Sets the current environment or context to the most recently used context. For example, the Exit-PSSession cmdlet places the user in the session that was used to start the interactive session.'
            SynonymsToAvoid = 'Pop;Out'
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Find'
            PairedWith      = ''
            Action          = "Looks for an object in a container that's unknown, implied, optional, or specified."
            SynonymsToAvoid = 'Search'
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Format'
            PairedWith      = ''
            Action          = 'Arranges objects in a specified form or layout'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Get'
            PairedWith      = 'Set'
            Action          = 'Specifies an action that retrieves a resource.'
            SynonymsToAvoid = 'Read;Open;Cat;Type;Dir;Obtain;Dump;Acquire;Examine;Find;Search'
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Hide'
            PairedWith      = 'Show'
            Action          = 'Makes a resource undetectable. For example, a cmdlet whose name includes the Hide verb might conceal a service from a user.'
            SynonymsToAvoid = 'Block'
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Join'
            PairedWith      = 'Split'
            Action          = 'Combines resources into one resource. For example, the Join-Path cmdlet combines a path with one of its child paths to create a single path.'
            SynonymsToAvoid = 'Combine;Unite;Connect;Associate'
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Lock'
            PairedWith      = 'Unlock'
            Action          = 'Secures a resource.'
            SynonymsToAvoid = 'Restrict;Secure'
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Move'
            PairedWith      = ''
            Action          = 'Moves a resource from one location to another. For example, the Move-Item cmdlet moves an item from one location in the data store to another location.'
            SynonymsToAvoid = 'Transfer;Name;Migrate'
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'New'
            PairedWith      = ''
            Action          = 'Creates a resource. (The Set verb can also be used when creating a resource that includes data, such as the Set-Variable cmdlet.)'
            SynonymsToAvoid = 'Create;Generate;Build;Make;Allocate'
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Open'
            PairedWith      = 'Close'
            Action          = 'Changes the state of a resource to make it accessible, available, or usable.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Optimize'
            PairedWith      = ''
            Action          = 'Increases the effectiveness of a resource.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Pop'
            PairedWith      = ''
            Action          = 'Removes an item from the top of a stack. For example, the Pop-Location cmdlet changes the current location to the location that was most recently pushed onto the stack.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Push'
            PairedWith      = ''
            Action          = 'Adds an item to the top of a stack. For example, the Push-Location cmdlet pushes the current location onto the stack.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Redo'
            PairedWith      = ''
            Action          = 'Resets a resource to the state that was undone.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Remove'
            PairedWith      = 'Add'
            Action          = 'Deletes a resource from a container. For example, the Remove-Variable cmdlet deletes a variable and its value.'
            SynonymsToAvoid = 'Clear;Cut;Dispose;Discard;Erase'
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Rename'
            PairedWith      = ''
            Action          = 'Changes the name of a resource. For example, the Rename-Item cmdlet, which is used to access stored data, changes the name of an item in the data store.'
            SynonymsToAvoid = 'Change'
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Reset'
            PairedWith      = ''
            Action          = 'Sets a resource back to its original state.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Common'
            Verb            = 'Resize'
            PairedWith      = ''
            Action          = 'Changes the size of a resource.'
            SynonymsToAvoid = ''
        }

    #========== COMMUNICATION ===============================================================
        [PSCustomObject]@{
            VerbType        = 'Communications'
            Verb            = 'Connect'
            PairedWith      = 'Disconnect'
            Action          = 'Creates a link between a source and a destination.'
            SynonymsToAvoid = 'Join;Telnet;Login'
        }
        [PSCustomObject]@{
            VerbType        = 'Communications'
            Verb            = 'Disconnect'
            PairedWith      = 'Connect'
            Action          = 'Breaks the link between a source and a destination.'
            SynonymsToAvoid = 'Break;Logoff'
        }
        [PSCustomObject]@{
            VerbType        = 'Communications'
            Verb            = 'Read'
            PairedWith      = 'Write'
            Action          = 'Acquires information from a source.'
            SynonymsToAvoid = 'Acquire;Prompt;Get'
        }
        [PSCustomObject]@{
            VerbType        = 'Communications'
            Verb            = 'Receive'
            PairedWith      = 'Send'
            Action          = 'Accepts information sent from a source.'
            SynonymsToAvoid = 'Read;Accept;Peek'
        }
        [PSCustomObject]@{
            VerbType        = 'Communications'
            Verb            = 'Send'
            PairedWith      = 'Receive'
            Action          = 'Delivers information to a destination.'
            SynonymsToAvoid = 'Put;Broadcast;Mail;Fax'
        }
        [PSCustomObject]@{
            VerbType        = 'Communications'
            Verb            = 'Write'
            PairedWith      = 'Read'
            Action          = 'Adds information to a target.'
            SynonymsToAvoid = 'Put;Print'
        }

    #========== DATA ===============================================================
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Backup'
            PairedWith      = ''
            Action          = 'Stores data by replicating it.'
            SynonymsToAvoid = 'Save;Burn;Replicate;Sync'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Checkpoint'
            PairedWith      = ''
            Action          = 'Creates a snapshot of the current state of the data or of its configuration.'
            SynonymsToAvoid = 'Diff'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Compare'
            PairedWith      = ''
            Action          = 'Evaluates the data from one resource against the data from another resource.'
            SynonymsToAvoid = 'Diff'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Compress'
            PairedWith      = 'Expand'
            Action          = 'Compacts the data of a resource.'
            SynonymsToAvoid = 'Compact'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Convert'
            PairedWith      = ''
            Action          = 'Changes the data from one representation to another when the cmdlet supports bidirectional conversion or when the cmdlet supports conversion between multiple data types.'
            SynonymsToAvoid = 'Change;Resize;Resample'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'ConvertFrom'
            PairedWith      = ''
            Action          = 'Converts one primary type of input (the cmdlet noun indicates the input) to one or more supported output types.'
            SynonymsToAvoid = 'Export;Output;Out'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'ConvertTo'
            PairedWith      = ''
            Action          = 'Converts from one or more types of input to a primary output type (the cmdlet noun indicates the output type).'
            SynonymsToAvoid = 'Import;Input;In'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Dismount'
            PairedWith      = 'Mount'
            Action          = 'Detaches a named entity from a location.'
            SynonymsToAvoid = 'Unmount;Unlink'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Edit'
            PairedWith      = ''
            Action          = 'Modifies existing data by adding or removing content.'
            SynonymsToAvoid = 'Change;Update;Modify'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Expand'
            PairedWith      = 'Compress'
            Action          = 'Restores the data of a resource that has been compressed to its original state.'
            SynonymsToAvoid = 'Explode;Uncompress'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Export'
            PairedWith      = 'Import'
            Action          = 'Encapsulates the primary input into a persistent data store, such as a file, or into an interchange format.'
            SynonymsToAvoid = 'Extract;Backup'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Group'
            PairedWith      = ''
            Action          = 'Arranges or associates one or more resources'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Import'
            PairedWith      = 'Export'
            Action          = "Creates a resource from data that's stored in a persistent data store (such as a file) or in an interchange format. For example, the Import-Csv cmdlet imports data from a comma-separated value (CSV) file to objects that can be used by other cmdlets."
            SynonymsToAvoid = 'BulkLoad;Load'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Initialize'
            PairedWith      = ''
            Action          = 'Prepares a resource for use, and sets it to a default state.'
            SynonymsToAvoid = 'Erase;Init;Renew;Rebuild;Reinitialize;Setup'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Limit'
            PairedWith      = ''
            Action          = 'Applies constraints to a resource.'
            SynonymsToAvoid = 'Quota'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Merge'
            PairedWith      = ''
            Action          = 'Creates a single resource from multiple resources.'
            SynonymsToAvoid = 'Combine;Join'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Mount'
            PairedWith      = 'Dismount'
            Action          = 'Attaches a named entity to a location.'
            SynonymsToAvoid = 'Connect'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Out'
            PairedWith      = ''
            Action          = 'Sends data out of the environment. For example, the Out-Printer cmdlet sends data to a printer.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Publish'
            PairedWith      = 'Unpublish'
            Action          = 'Makes a resource available to others.'
            SynonymsToAvoid = 'Deploy;Release;Install'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Restore'
            PairedWith      = ''
            Action          = 'Sets a resource to a predefined state, such as a state set by Checkpoint. For example, the Restore-Computer cmdlet starts a system restore on the local computer.'
            SynonymsToAvoid = 'Repair;Return;Undo;Fix'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Save'
            PairedWith      = ''
            Action          = 'Preserves data to avoid loss.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Sync'
            PairedWith      = ''
            Action          = 'Assures that two or more resources are in the same state.'
            SynonymsToAvoid = 'Replicate;Coerce;Match'
        }
        [PSCustomObject]@{
            VerbType        = 'Data'
            Verb            = 'Unpublish'
            PairedWith      = 'Publish'
            Action          = 'Makes a resource unavailable to others.'
            SynonymsToAvoid = 'Uninstall;Revert;Hide'
        }

    #========== DIAGNOSTIC ===============================================================
        [PSCustomObject]@{
            VerbType        = 'Diagnostic'
            Verb            = 'Debug'
            PairedWith      = ''
            Action          = 'Examines a resource to diagnose operational problems.'
            SynonymsToAvoid = 'Diagnose'
        }
        [PSCustomObject]@{
            VerbType        = 'Diagnostic'
            Verb            = 'Measure'
            PairedWith      = ''
            Action          = 'Identifies resources that are consumed by a specified operation, or retrieves statistics about a resource.'
            SynonymsToAvoid = 'Calculate;Determine;Analyze'
        }
        [PSCustomObject]@{
            VerbType        = 'Diagnostic'
            Verb            = 'Ping'
            PairedWith      = ''
            Action          = 'Deprecated - Use the Test verb instead.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Diagnostic'
            Verb            = 'Repair'
            PairedWith      = ''
            Action          = 'Restores a resource to a usable condition'
            SynonymsToAvoid = 'Fix;Restore'
        }
        [PSCustomObject]@{
            VerbType        = 'Diagnostic'
            Verb            = 'Resolve'
            PairedWith      = ''
            Action          = 'Maps a shorthand representation of a resource to a more complete representation.'
            SynonymsToAvoid = 'Expand;Determine'
        }
        [PSCustomObject]@{
            VerbType        = 'Diagnostic'
            Verb            = 'Test'
            PairedWith      = ''
            Action          = 'Verifies the operation or consistency of a resource.'
            SynonymsToAvoid = 'Diagnose;Analyze;Salvage;Verify'
        }
        [PSCustomObject]@{
            VerbType        = 'Diagnostic'
            Verb            = 'Trace'
            PairedWith      = ''
            Action          = 'Tracks the activities of a resource.'
            SynonymsToAvoid = 'Track;Follow;Inspect;Dig'
        }

    #========== LIFECYCL ===============================================================
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Approve'
            PairedWith      = ''
            Action          = 'Confirms or agrees to the status of a resource or process.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Assert'
            PairedWith      = ''
            Action          = 'Affirms the state of a resource.'
            SynonymsToAvoid = 'Certify'
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Build'
            PairedWith      = ''
            Action          = 'Creates an artifact (usually a binary or document) out of some set of input files (usually source code or declarative documents.) This verb was added in PowerShell 6.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Complete'
            PairedWith      = ''
            Action          = 'Concludes an operation.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Confirm'
            PairedWith      = ''
            Action          = 'Acknowledges, verifies, or validates the state of a resource or process.'
            SynonymsToAvoid = 'Acknowledge;Agree;Certify;Validate;Verify'
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Deny'
            PairedWith      = ''
            Action          = 'Refuses, objects, blocks, or opposes the state of a resource or process.'
            SynonymsToAvoid = 'Block;Object;Refuse;Reject'
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Deploy'
            PairedWith      = ''
            Action          = 'Sends an application, website, or solution to a remote target[s] in such a way that a consumer of that solution can access it after deployment is complete. This verb was added in PowerShell 6.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Disable'
            PairedWith      = 'Enable'
            Action          = 'Configures a resource to an unavailable or inactive state. For example, the Disable-PSBreakpoint cmdlet makes a breakpoint inactive.'
            SynonymsToAvoid = 'Halt;Hide'
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Enable'
            PairedWith      = 'Disable'
            Action          = 'Configures a resource to an available or active state. For example, the Enable-PSBreakpoint cmdlet makes a breakpoint active.'
            SynonymsToAvoid = 'Start;Begin'
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Install'
            PairedWith      = 'Uninstall'
            Action          = 'Places a resource in a location, and optionally initializes it.'
            SynonymsToAvoid = 'Setup'
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Invoke'
            PairedWith      = ''
            Action          = 'Performs an action, such as running a command or a method.'
            SynonymsToAvoid = 'Run;Start'
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Register'
            PairedWith      = 'Unregister'
            Action          = 'Creates an entry for a resource in a repository such as a database.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Request'
            PairedWith      = ''
            Action          = 'Asks for a resource or asks for permissions.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Restart'
            PairedWith      = ''
            Action          = 'Stops an operation and then starts it again. For example, the Restart-Service cmdlet stops and then starts a service.'
            SynonymsToAvoid = 'Recycle'
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Resume'
            PairedWith      = 'Suspend'
            Action          = 'Starts an operation that has been suspended. For example, the Resume-Service cmdlet starts a service that has been suspended.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Start'
            PairedWith      = 'Stop'
            Action          = 'Initiates an operation. For example, the Start-Service cmdlet starts a service.'
            SynonymsToAvoid = 'Launch;Initiate;Boot'
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Stop'
            PairedWith      = 'Start'
            Action          = 'Discontinues an activity.'
            SynonymsToAvoid = 'End;Kill;Terminate;Cancel'
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Submit'
            PairedWith      = ''
            Action          = 'Presents a resource for approval.'
            SynonymsToAvoid = 'Post'
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Suspend'
            PairedWith      = 'Resume'
            Action          = 'Pauses an activity. For example, the Suspend-Service cmdlet pauses a service.'
            SynonymsToAvoid = 'Pause'
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Uninstall'
            PairedWith      = 'Install'
            Action          = 'Removes a resource from an indicated location.'
            SynonymsToAvoid = ''
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Unregister'
            PairedWith      = 'Register'
            Action          = 'Removes the entry for a resource from a repository.'
            SynonymsToAvoid = 'Remove'
        }
        [PSCustomObject]@{
            VerbType        = 'Lifecycle'
            Verb            = 'Wait'
            PairedWith      = ''
            Action          = 'Pauses an operation until a specified event occurs. For example, the Wait-Job cmdlet pauses operations until one or more of the background jobs are complete.'
            SynonymsToAvoid = 'Sleep;Pause'
        }

    #========== SECURITY ===============================================================
        [PSCustomObject]@{
            VerbType        = 'Security'
            Verb            = 'Block'
            PairedWith      = 'Unblock'
            Action          = 'Restricts access to a resource.'
            SynonymsToAvoid = 'Prevent;Limit;Deny'
        }
        [PSCustomObject]@{
            VerbType        = 'Security'
            Verb            = 'Grant'
            PairedWith      = 'Revoke'
            Action          = 'Allows access to a resource.'
            SynonymsToAvoid = 'Allow;Enable'
        }
        [PSCustomObject]@{
            VerbType        = 'Security'
            Verb            = 'Protect'
            PairedWith      = 'Unprotect'
            Action          = 'Safeguards a resource from attack or loss.'
            SynonymsToAvoid = 'Encrypt;Safeguard;Seal'
        }
        [PSCustomObject]@{
            VerbType        = 'Security'
            Verb            = 'Revoke'
            PairedWith      = 'Grant'
            Action          = "Specifies an action that doesn't allow access to a resource."
            SynonymsToAvoid = 'Remove;Disable'
        }
        [PSCustomObject]@{
            VerbType        = 'Security'
            Verb            = 'Unblock'
            PairedWith      = 'Block'
            Action          = 'Removes restrictions to a resource.'
            SynonymsToAvoid = 'Clear;Allow'
        }
        [PSCustomObject]@{
            VerbType        = 'Security'
            Verb            = 'Unprotect'
            PairedWith      = 'Protect'
            Action          = 'Removes safeguards from a resource that were added to prevent it from attack or loss.'
            SynonymsToAvoid = 'Decrypt;Unseal'
        }

    #========== OTHER ===============================================================
        [PSCustomObject]@{
            VerbType        = 'Other'
            Verb            = 'Use'
            PairedWith      = ''
            Action          = 'Uses or includes a resource to do something.'
            SynonymsToAvoid = ''
        }
    )
    return ($ApprovedVerbs | Sort-Object VerbType, verb)
}
