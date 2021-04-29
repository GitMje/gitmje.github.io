---
layout:     post
title:      PowerShell Streams
date:       2021-04-27 22:00:00
author:     Michael Erpenbeck
summary:    PowerShell Streams
categories: PowerShell
thumbnail:  jekyll
tags:
 - PowerShell
---

I've put together the information below as a guide for some PowerShell Stream concepts that I've found are not well understood by most engineers.  Streams are a fantastic structure built by the PowerShell team, but have not been well communicated.

## Basics

![basic](/assets/2021-04-28-powershell-streams/1.png)

Most computing systems are built around only three standard streams: **stdin** (stardard in), **stdout** (standard out), and **stderr** (standard error).  PowerShell is build with 6 standard output streams (as shown below).  Note, as of this writing, the Progress Stream is under development.


When the cmdlet runs, some of the streams are enabled by default (a value of "Continue") and some are not (a value of "SilentlyContinue").  As an example, the Success/Output, Error stream, and Warning streams are enabled by default and the Verbose and Debug streams are not.  

So running a command like `Write-Verbose -Message 'Hello World!'` results in no operation.  These streams can be enabled by using the Cmdlet's common parameters.  For example, `Write-Verbose -Message 'Hello World!' -Verbose` will result in `VERBOSE: Hello World!` being displayed on the commandline.  The `-Verbose` flag tells the cmdlet to enable the verbose stream with this operation.  Similarly in a script, you can use a Preference Variable like `$VerbosePreference = 'Continue'`.  This will result in the entire script enabling the verbose stream.  So the same command of `Write-Verbose -Message 'Hello World'` will result in `VERBOSE: Hello World!` being displayed on the commandline.

## Table of output Streams

![pipeline](/assets/2021-04-28-powershell-streams/1_1.png)

Note that [`Write-Host`](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/write-host){:target="_blank"} has been refactored starting in PowerShell 5.0 to be a wrapper around the `Write-Information` cmdlet.

## How streams work in PowerShell pipelines

![pipeline](/assets/2021-04-28-powershell-streams/2.png)

When running a cmdlet and piping the output to another cmdlet, only the Success/Output stream is passed from the first cmdlet (Cmdlet A in the image) to the second cmdlet (Cmdlet B in the image).  This is what the "Output" portion of the stream name signifies.  As an example, running:
`Get-Process | Where-Object {$_.ProcessName -eq 'chrome'}`

Will result in an output like the following where the Success/Output stream pushes an array of objects from the `Get-Process` cmdlet to the `Where-Object` cmdlet that uses the values to filter the object's data.  Note that the other streams are not passed in the pipeline.

![example execution](/assets/2021-04-28-powershell-streams/2_1.png)

## Redirection operator deep dive

![redirection](/assets/2021-04-28-powershell-streams/3.png)

Since the Verbose stream is not passed through the pipeline, operations like the following do not get passed from the `Write-Verbose` to the `Out-File` and the "B.txt" file is created but is empty.

`Write-Verbose -Message 'Hello World!' -Verbose | Out-File .\B.txt`

The redirection operator `4>&1` looks cryptic, but it makes sense when you parse it.  It means that the Verbose stream (4) is redirected to the Success/Output Stream (1).

`Write-Verbose -Message 'Hello World!' -Verbose 4>&1 | Out-File .\B.txt`

The result is as shown.

![pipeline](/assets/2021-04-28-powershell-streams/3_1.png)

## More information

- [PowerShell Streams](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_output_streams?view=powershell-7.1#long-description){:target="_blank"}
- [PowerShell Preference Variables](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_preference_variables){:target="_blank"}
- [PowerShell Redirection](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_redirection){:target="_blank"}

- [Cmdlet Common Parameters](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_commonparameters){:target="_blank"}

- [Redirection operators](https://www.sconstantinou.com/powershell-redirection-operators/)){:target="_blank"}
- [Understanding Streams, Redirection, and Write-Host in PowerShell](https://devblogs.microsoft.com/scripting/understanding-streams-redirection-and-write-host-in-powershell/)){:target="_blank"}