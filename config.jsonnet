local firebase = import 'firebase.libsonnet';

local go_modules = ['evy', 'foxtrot', 'jcdc', 'jig', 'jsonnext', 'protog', 's', 'servedir'];
local file_repos = ['jsonnext'];

// See https://firebase.google.com/docs/hosting/full-config
local firebase_config = {
  hosting: {
    public: 'public',
    ignore: [
      'firebase.json',
      '**/.*',
    ],
  },
};

// This object is the output of jsonnet. It is intended to be run with
// jsonnet -m, which produces multiple output files based on the object that
// this expression generates, where the keys are the filenames and the values
// are the contents to be put into that file. Each value should be a string.
firebase.html_redirects(go_modules) + {
  'firebase.json': std.manifestJsonEx(
    firebase_config + firebase.file_repo_redirects(file_repos), '   '
  ) + '\n',
}
