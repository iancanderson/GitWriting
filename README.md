# GitWriting

Features
- [x] Exclude hidden files
- [x] Show contents of file in detail view
- [x] Render text contents in UITextView instead of UILabel
- [x] Put note filename in title bar
- [x] Put repo name in title bar
- [x] Create new empty note with filename: `YYYY-MM-DD-:name`
- [x] Delete note file
- [x] Edit note's contents, update corresponding file contents
- [x] Save file with .md extension
- [x] Open note automatically after creating it
- [x] Auto-commit to master
  - [x] Auto-commit when:
    - [x] delete note
    - [x] editing note (every n seconds?)
    - [x] new note (commits as soon as you actually add note contents)
- [x] Store github token in Keychain
- [x] Get push working without having to manually edit .git/config (See Hacks below)

TODO:
- [ ] Auto-push to master
- [ ] Use credentials to clone private repo
- [ ] On startup, git pull origin master

Maybe
- [ ] Commit to an autosave branch instead of master
- [ ] markdown preview
- [ ] Show diff against master before "saving"
- [ ] Pin important notes to the top
- [ ] Exclude directories from file listing?
