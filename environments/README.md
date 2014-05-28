
# http://docs.opscode.com/knife_environment.html#from-file
# $ knife environment create devops from file "path to JSON file"



$ knife environment create development from file environments/development.json
$ knife environment create production from file environments/production.json
$ knife environment create testing from file environments/testing.json
$ knife environment create acceptance from file environments/acceptance.json

# ps: dont forget to set:
# $ export EDITOR=vim
