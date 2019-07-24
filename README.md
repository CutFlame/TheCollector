# The Collector
## Overview

Small example app showing the MVVM-Coordinator architecture / design pattern.

## Setup

run `make Carthage`

## Unit Tests

run `make test`

## Architecture / Layers

Coordinators 
- in charge of the flow of the app
- creates the ViewModel
- subscribes to events on the ViewModel
- creates the ViewController configured with the ViewModel and optionally the View
- displays the ViewController

 |
 
ViewControllers
- binds the View (UI) to the ViewModel

 |

ViewModels
- created with all the data needed to pull what it needs from the database
- holds all data to be displayed and to be manipulated
- includes pointers to databases/services to access the data

 |

Databases
- singleton to hold all the data
- has CRUD methods to access the data
