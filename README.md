# Issue votes

The Issue Votes plugin adds voting functionality to issues, allowing a project to include users into the development workflow

## Installation (Redmine 3.x.x) ##

* Clone the plugin to the Redmine plugins-folder and do the rake task: rake redmine:plugins:migrate and restart Rails server.

## Permissions ##

* Voting for an issue requires the admin to toggle the 'vote issue' permission for the wanted roles.
* Viewing vote-related activities under a project's /activities -tab requires the 'view vote activities' permission.
* Viewing the voting report for an issue requires the admin to toggle the 'view votes' permission for the wanted roles.
