@{

RootModule = 'VAR_ROOTMODULE.psm1'
ModuleVersion = '1.0.0'
GUID = 'VAR_PSD1GUID'

Author = 'VAR_AUTHOR'
CompanyName = 'VAR_COMPANYNAME'
HelpInfoURI = 'VAR_HELPINFOURI'
Copyright = '(c) VAR_AUTHOR. All rights reserved.'

Description = 'VAR_DESCRIPTION'
PowerShellVersion = 'VAR_PSVERSION'

# Functions to export from this module
# ====================================
# FunctionsToExport = '*' #ALL_Functions
# or
# FunctionsToExport = @('Get-Function01','Get-Function02') #Specific_Functions_Only

# Private data to pass to the module specified in RootModule/ModuleToProcess. 
# This may also contain a Module_Template hashtable with additional module metadata used by PowerShell.

PrivateData = @{
    # ----------------------------------------------------------------------------------------------------------
    PSData = @{
        Tags = @('TAG01', 'TAG02', 'TAG03')
        LicenseUri = 'VAR_LICENSEURI'
        ProjectUri = 'VAR_GITPROJECTURI'
        IconUri = 'VAR_ICONURI'
        ReleaseNotes = 'VAR_RELEASENOTES'
    } # End of Module_Template hashtable
   # ----------------------------------------------------------------------------------------------------------
} # End of PrivateData hashtable


<#
================================================================================================
Module Settings Not used
================================================================================================
# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module
# CLRVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Cmdlets to export from this module
# CmdletsToExport = '*'

# Variables to export from this module
# VariablesToExport = '*'

# Aliases to export from this module
# AliasesToExport = '*'

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @()

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

#>
}


