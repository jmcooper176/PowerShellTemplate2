                                                  #################

                                                #     ###       #
                                                      #  #
                                              #       ###     #
                                                      #
                                            #         # *   #
                                                       *  
                                          #             * #
                                                       *
                                        #               *
                                       #################

[![latest version](https://img.shields.io/nuget/vpre/PowerShell2)](https://www.nuget.org/packages/PowerShell2)
[![download count](https://img.shields.io/nuget/dt/powershell2)](https://www.nuget.org/stats/packages/PowerShell2?groupby=Version)
[![build status](https://img.shields.io/github/actions/workflow/status/jmcooper176/PowerShell2/build.yml?branch=main)](https://github.com/jmcooper176/PowerShell2/actions/workflows/build.yml?query=branch%3Amain)

# PowerShell Template

This repository contains PowerShell templates together with the infrastructure
code necessary to deploy them.

# Developing PowerShell Template

## Prerequisites

- A command line Git client that is in the system path
- Visual Studio Code (1.90.1 or higher)
- Visual Studio 2022 (17.10.4 or higher) with the following installed:

| Workloads |
| :-------- |
| .NET Desktop Development |

| Individual Components |
| :-------------------- |
| PowerShell Core 7.4.x or later |
| .NET 6.0 Runtime (Long Term Support) |
| .NET Framework 4.7.2 SDK |
| .NET Framework 4.7.2 targeting pack |
| Optional:  PowerShell Pro Visual Studio/VSCode Extension (Ironman Software) |

- [Download the latest nuget.exe command-line tool]
  (https://www.nuget.org/downloads) (v6.9.0 or later) and put it in a directory on the path.

### Getting Started:

* [Fork the PowerShell2 repository](https://github.com/jmcooper176/PowerShell2)
 into your own GitHub repository
* Clone the PowerShell2 repository from your fork (`git clone https://github.com/yourdomain/PowerShell2.git`)
 into the directory of your choice

 ### Pull Request Expectations:

 * Pick an [outstanding WiX issue](https://github.com/jmcooper176/PowerShell2/issues/issues?q=is%3Aissue+is%3Aopen+label%3A%22up+for+grabs%22) (or [create a new one](https://github.com/jmcooper176/PowerShell2/issues/issues/new/choose)). Add a comment requesting that you be assigned to the issue. Wait for confirmation.
 * To create a pull request, [fork a new branch](https://github.com/jmcooper176/PowerShell2/) from the `main` branch
 * Make changes to effect whatever changed behavior is required for the pull request
 * Push the changes to your repository origin as needed
 * If the `main` branch has changed since you created your branch, **rebase** to the latest updates.
 * If needed (ie, you squashed or rebased), do a force push of your branch
 * Create a pull request with your branch against the PowerShell2 repository.**

 ### PowerShell Template

#### PowerShell Class Template

#### PowerShell Class Pester Unit Tests Template

#### PowerShell Enum Template

#### PowerShell Function/Cmdlet Template

#### PowerShell Function/Cmdlet Unit Tests Template

#### PowerShell Script Module Manifest Templates

##### PowerShell Script Module Manifest for Function/Cmdlet Template

##### PowerShell Script Module Manifest for Class Template
