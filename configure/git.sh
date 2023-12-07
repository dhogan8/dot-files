echo 'git config'

git config --global user.name 'Dallas Hogan'
#git config --global user.email 'dallastar4@gmail.com'

git config --global branch.autosetuprebase always
git config --global color.ui "auto"
#git config --global github.user dhogan8

git config --global alias.b 'branch'
git config --global alias.ca 'commit --amend'
git config --global alias.can 'commit --amend --no-edit'
git config --global alias.ct 'commit'
git config --global alias.co 'checkout'
git config --global alias.dc 'diff --cached'
git config --global alias.doms 'diff -w -M origin/main...HEAD --stat --name-only'
git config --global alias.prom 'pull --rebase origin main'
git config --global alias.pf 'push --force-with-lease'
git config --global alias.undo 'reset --soft HEAD^'
git config --global alias.st 'status'
git config --global alias.gra 'rebase -i --autosquash'
git config --global alias.root "rev-parse --show-toplevel"

# configure delta as git's pager
git config --global core.pager 'delta'
git config --global delta.light false
git config --global delta.navigate true
git config --global diff.colorMoved default
git config --global interactive.diffFilter 'delta --color-only'
