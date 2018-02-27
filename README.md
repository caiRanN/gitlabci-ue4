# Setting up Gitlab CI Automation for Unreal Engine 4

This tutorial provides documentation and resources on how to configure Gitlab CI to compile and build your Unreal Engine 4 project.

This tutorial, repository and files are based on the great [Jenkins tutorial](https://github.com/skymapgames/jenkins-ue4), check it out if you would like to use Jenkins instead!

Created by [Cairan Steverink](https://cairansteverink.nl).

---

### Prerequisites

**Before you begin:** Set up your Gitlab repository as normal and clone it to your desktop.

**Note:** This documentation is solely meant to configure a Gitlab runner on Windows servers and desktops.
We will configure our pipeline so that it will only archive our builds during scheduled builds and manual builds started through the Gitlab interface. This way we prevent flooding our disk space with archived builds.

### Setting up the Runner

Gitlab uses runners to run the jobs defined in the .gitlab-ci.yml file (_which we will create at the end of this tutorial_). We will set up a Windows desktop as our runner.

Download the runner executable from [Gitlab](https://docs.gitlab.com/runner/install/windows.html) and follow the installation process described in the documentation.

#### Register the Runner

Now we need to register our runner. Inside your Gitlab project go to **Settings -> CI/CD -> General pipelines settings** and obtain the runner token.

Follow the registration progress described in the [documentation](https://docs.gitlab.com/runner/register/#windows) but **do not enter any tags** when prompted. Finaly pick **Shell** as your executor after which we should have our runner set up.

#### Register the Runner

Download the build scripts and move them to another folder. For example: C:/BuildScripts/.
Make sure you replace PROJECT_NAME inside the scripts with the name of your project.

### Creating a Gitlab Pipeline

Once we have our runner set up we can configure our pipeline. Start by creating a **.gitlab-ci.yml** file inside your repository. This file tells the Gitlab runner what to do when a pipeline is triggered.

Add the following to the .gitlab-ci.yml file. Commit the file and your pipeline should be triggered. If you have any questions, suggestions or feedback feel free to contact me.

```yml
variables:
  GIT_STRATEGY: none        # we disable fetch, clone or checkout for every job
  GIT_CHECKOUT: "false"     # as we only want to checkout or fetch in the preperation stage

stages:
  - preperations
  - compile
  - build
  - cook
  - package

preperations:
  stage: preperations
  variables:
    GIT_STRATEGY: fetch
    GIT_CHECKOUT: "true"
  script:
    - call "C:\PATH_TO_FILES\StartBuild.bat"

compile:
  stage: compile
  script:
    - call "C:\PATH_TO_FILES\CompileScripts.bat"

build:
  stage: build
  script:
    - call "C:\PATH_TO_FILES\BuildFiles.bat"

cook:
  stage: cook
  script: 
    - call "C:\PATH_TO_FILES\CookProject.bat"

package:
  stage: package
  only:
    - web                 # only archive when started through the web interface
    - schedules           # only archive when started at a specific schedule
  script:
    - echo "Adding build to the artifacts"
    - call C:\PATH_TO_FILES\Archive.bat
  artifacts:
    paths:
      - PROJECT_NAME.zip
    expire_in: 5 days
```


