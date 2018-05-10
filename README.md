# GitWriting

To enable git-pushing, I needed to add the push line to the repo's .git/config file:

```
[remote "origin"]
	url = https://github.com/iancanderson/notes-test
	fetch = +refs/heads/*:refs/remotes/origin/*
	push = refs/heads/master:refs/heads/master
```
