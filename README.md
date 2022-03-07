# clus_workshop_base

Contains content and config for the workshop hands-on labs. 

## Files

- /devenv-dne/requirements.txt - libraries for the in-browser dev environment
- /devenv-dne/Dockerfile - commands to  build the docker container
- /devenv-dne/Makefile - commands to run the docker container such as "make build", "make run"
- /devenv-dne/src/ - folders for each of the code files for each of the labs

## Run the in-browser dev environment locally:

1. Create clone or fork of this repo
2. Create a branch in your forked repo
3. cd devenv-dne (make sure you're in that directory)
4. make build (to build it)
5. make run (to run it)
6. Open http://localhost:1001?arg=secret to see the terminal in your browser
7. Open localhost:1002 to see the file editor in your browser

# Authoring/reviewing guidelines for hands-on labs

* Hands-on labs must have no commands or code pastes in the first page, because that is where the “Start learning” button is and needs to be pressed to launch the container.

* Hands-on labs must have an H2 Summary at the end of the last page (## Summary). The summary does not need to be in a separate Markdown file.

* Filenames for the markdown files should follow an 01, 02 (not 001, 002) naming convention because hands-on labs should not have more than 10 markdown files.

* Hands-on labs cannot have numbered lists due to a bug in the platform where all numbers show up as one when you have triplebacktick python or triplebacktick bash, and if you indent as you would typically do in Markdown, the code breaks due to added white space.

* Hands-on labs generally should have separate files for each code example. 


* Each hands-on lab contains blank Python files so that the user can copy/paste code into that file in the browser environment. Then they execute the file in the terminal. 

* You will want to create a new folder for the new hands-on lab in the /devenv-dne/src/ folder and then add the Python or other script files in there.

* Please make sure that each empty file contains a comment at the top such as "# Add to this file for the containers lab."

* After the files have been added, you will need to create new .md files in the lab repo and setup the config.json file.
