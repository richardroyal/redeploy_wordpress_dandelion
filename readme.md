## Simple redeployment of WP Sites via dandelion

1. Checkout project git repo 
2. Create tmp test install with WP CLI tool
3. Update WP core and Plugins using WP CLI
4. Delete dandelion revision file on server
5. Deploy with dandelion

This allows you to easily re-deploy a fresh copy of the project files to the server directly over the old files to force reset and potentially compromised files.

### Usage

```sh
./redeploy_wordpress_dandelion www.example.com example_coms_git_repo
```

First argument is the root folder name on the server. The production folder should be under the root folder.
Second argument is the git repo name. The base git URL is contained in the config file.

This allows easy mass redeployment in the event of a potential breach.

```sh
./redeploy_wordpress_dandelion www.example1.com example1_coms_git_repo
./redeploy_wordpress_dandelion www.example2.com example2_coms_git_repo
./redeploy_wordpress_dandelion www.example3.com example3_coms_git_repo
.
.
.

```

### Requirements:

* Ruby 1.9.3
* dandelion
* WP CLI
* ncftp 

### Assumes:

* You are deploying WP Sites to a PHP-site container via dandelion. For example, Rackspace Cloudsites.
* dandelion.yml deploys to production
* You setup the config.cfg file correctly
* FTP credentials are the same for each site deployment - agency level access
  * You could extract the FTP credentials into command line arguments

